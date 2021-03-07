defmodule DsaWeb.CharacterController do
  use DsaWeb, :controller

  alias Dsa.Accounts
  alias Dsa.Accounts.Character

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def activate(conn, %{"character_id" => id}, current_user) do
    character = Accounts.get_user_character!(current_user, id)

    case Accounts.activate_character(current_user, character) do
      {:ok, _user} ->
        redirect(conn, to: Routes.character_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Error updating user: \n#{inspect(changeset.errors)}")

        conn
        |> put_flash(:info, "An error occured when updating user.")
        |> redirect(to: Routes.character_path(conn, :index))
    end
  end

  def index(conn, _params, current_user) do
    characters = Accounts.list_user_characters(current_user)
    render(conn, "index.html", characters: characters)
  end

  def show(conn, %{"id" => id}, current_user) do
    character = Accounts.get_user_character!(current_user, id)
    render(conn, "show.html", character: character)
  end

  def edit(conn, %{"id" => id}, current_user) do
    character = Accounts.get_user_character!(current_user, id)
    changeset = Accounts.change_character(character)
    render(conn, "edit.html", character: character, changeset: changeset)
  end

  def update(conn, %{"id" => id, "character" => character_params}, current_user) do
    character = Accounts.get_user_character!(current_user, id)

    case Accounts.update_character(character, character_params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character updated successfully.")
        |> redirect(to: Routes.character_path(conn, :edit, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", character: character, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    character = Accounts.get_user_character!(current_user, id)
    {:ok, _character} = Accounts.delete_character(character)

    conn
    |> put_flash(:info, "Character deleted successfully.")
    |> redirect(to: Routes.character_path(conn, :index))
  end

  def new(conn, _params, _current_user) do
    changeset = Accounts.change_character(%Character{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"character" => character_params}, current_user) do
    case Accounts.create_character(current_user, character_params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, gettext("Character created successfully."))
        |> redirect(to: Routes.character_path(conn, :edit, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def toggle_visible(conn, %{"id" => id}, current_user) do
    character = Accounts.get_user_character!(current_user, id)

    case Accounts.update_character(character, %{visible: !character.visible}) do
      {:ok, _character} ->
        redirect(conn, to: Routes.character_path(conn, :index))

      {:error, changeset} ->
        Logger.error("Error updating character: \n#{inspect(changeset.errors)}")

        conn
        |> put_flash(:info, "An error occured when updating character.")
        |> redirect(to: Routes.character_path(conn, :index))
    end
  end
end
