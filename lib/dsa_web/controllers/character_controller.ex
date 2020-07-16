defmodule DsaWeb.CharacterController do
  use DsaWeb, :controller

  alias Dsa.Accounts

  def index(conn, _params, _user), do: render conn, "index.html"

  def new(conn, _params, _user) do
    render conn, "new.html",
      changeset: Accounts.change_character(%Accounts.Character{}),
      groups: Accounts.list_groups()
  end


  def create(conn, %{"character" => params}, current_user) do
    case Accounts.create_character(current_user, params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character erfolgreich erstellt!")
        |> redirect(to: Routes.character_path(conn, :edit, character))

      {:error, changeset} ->
        render conn, "new.html", changeset: changeset, groups: Accounts.list_groups()
    end
  end

  def edit(conn, %{"id" => id}, user) do
    changeset = user |> Accounts.get_user_character!(id) |> Accounts.change_character()
    render conn, "edit.html", changeset: changeset, groups: Accounts.list_groups()
  end

  def update(conn, %{"id" => id, "character" => params}, user) do
    character = Accounts.get_user_character!(user, id)
    groups = Accounts.list_groups()

    case Accounts.update_character(character, params) do
      {:ok, character} ->
        changeset =
          character
          |> Dsa.Repo.preload([:group, character_skills: :skill])
          |> Accounts.change_character()
        conn
        |> put_flash(:info, "Character updated successfully.")
        |> render("edit.html", changeset: changeset, groups: groups)
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset, groups: groups)
    end
  end


  def delete(conn, %{"id" => id}, current_user) do
    current_user
    |> Accounts.get_user_character!(id)
    |> Accounts.delete_character!()

    conn
    |> put_flash(:info, "Character deleted successfully.")
    |> redirect(to: Routes.character_path(conn, :index))
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end
end
