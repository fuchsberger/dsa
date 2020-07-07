defmodule DsaWeb.CharacterController do
  use DsaWeb, :controller

  alias Dsa.Game

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    characters = Game.list_user_characters(current_user)
    render(conn, DsaWeb.GameView, "index.html", characters: characters)
  end

  def delete(conn, %{"id" => id}, current_user) do
    current_user
    |> Game.get_user_character!(id)
    |> Game.delete_character!()

    conn
    |> put_flash(:info, "Character deleted successfully.")
    |> redirect(to: Routes.character_path(conn, :index))
  end
end
