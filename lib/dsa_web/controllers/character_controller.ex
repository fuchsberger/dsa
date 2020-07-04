defmodule DsaWeb.CharacterController do
  use DsaWeb, :controller

  alias Dsa.Game
  alias Dsa.Game.Character

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    characters = Game.list_user_characters(current_user)
    render(conn, "index.html", characters: characters)
  end

  def new(conn, _params, _current_user) do
    changeset = Game.change_character(%Character{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"character" => character_params}, current_user) do
    case Game.create_character(current_user, character_params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character created successfully.")
        |> redirect(to: Routes.character_path(conn, :show, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    character = Game.get_user_character!(current_user, id)
    render(conn, "show.html", character: character)
  end

  def edit(conn, %{"id" => id}, current_user) do
    character = Game.get_user_character!(current_user, id)
    changeset = Game.change_character(character)
    render(conn, "edit.html", character: character, changeset: changeset)
  end

  def update(conn, %{"id" => id, "character" => character_params}, current_user) do
    character = Game.get_user_character!(current_user, id)

    case Game.update_character(character, character_params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character updated successfully.")
        |> redirect(to: Routes.character_path(conn, :show, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", character: character, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    character = Game.get_user_character!(current_user, id)
    {:ok, _character} = Game.delete_character(character)

    conn
    |> put_flash(:info, "Character deleted successfully.")
    |> redirect(to: Routes.character_path(conn, :index))
  end
end
