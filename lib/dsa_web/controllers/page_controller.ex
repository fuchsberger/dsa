defmodule DsaWeb.PageController do
  use DsaWeb, :controller

  require Logger
  alias Dsa.{Accounts, Lore}

  def create_character(conn, _) do
    case Accounts.create_character(conn.assigns.current_user) do
      :error -> redirect(conn, to: Routes.character_path(conn, :index))
      character_id -> redirect(conn, to: Routes.character_path(conn, :edit, character_id))
    end
  end

  def seed(conn, _) do
    if conn.assigns.current_user.admin, do: Lore.seed()
    redirect(conn, to: Routes.manage_path(conn, :traits))
  end
end
