defmodule DsaWeb.CharacterController do
  use DsaWeb, :controller

  alias Dsa.Game

  def index(conn, _params, user) do
    render conn, "index.html", characters: Game.list_characters(user)
  end

  def new(conn, _params, _user) do
    render conn, "new.html",
      changeset: Game.change_character(%Game.Character{}),
      groups: Game.list_groups()
  end


  def create(conn, %{"character" => params}, current_user) do
    case Game.create_character(current_user, params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character erfolgreich erstellt!")
        |> redirect(to: Routes.character_path(conn, :edit, character))

      {:error, changeset} ->
        render conn, "new.html", changeset: changeset, groups: Game.list_groups()
    end
  end

  def edit(conn, %{"id" => id}, user) do
    changeset = user |> Game.get_user_character!(id) |> Game.change_character()
    render conn, "edit.html", changeset: changeset, groups: Game.list_groups()
  end

  def update(conn, %{"id" => id, "character" => params}, user) do
    character = Game.get_user_character!(user, id)
    groups = Game.list_groups()

    case Game.update_character(character, params) do
      {:ok, character} ->
        changeset =
          character
          |> Dsa.Repo.preload([:group, character_skills: :skill])
          |> Game.change_character()
        conn
        |> put_flash(:info, "Character updated successfully.")
        |> render("edit.html", changeset: changeset, groups: groups)
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset, groups: groups)
    end
  end


  def delete(conn, %{"id" => id}, current_user) do
    current_user
    |> Game.get_user_character!(id)
    |> Game.delete_character!()

    conn
    |> put_flash(:info, "Character deleted successfully.")
    |> redirect(to: Routes.character_path(conn, :index))
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end
end
