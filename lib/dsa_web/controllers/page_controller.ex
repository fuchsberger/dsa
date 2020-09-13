defmodule DsaWeb.PageController do
  use DsaWeb, :controller

  require Logger
  alias Dsa.Accounts

  def create_character(conn, _) do
    case Accounts.create_character(conn.assigns.current_user) do
      :error -> redirect(conn, to: Routes.character_path(conn, :index))
      character_id -> redirect(conn, to: Routes.character_path(conn, :edit, character_id))
    end
  end
end
