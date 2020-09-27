defmodule DsaWeb.PageController do
  use DsaWeb, :controller

  require Logger
  alias Dsa.Accounts

  def create_character(conn, _) do
    case Accounts.create_character(conn.assigns.current_user) do
      :error ->
        redirect(conn, to: Routes.manage_path(conn, :characters))

      character_id ->
        redirect(conn, to: Routes.live_path(conn, DsaWeb.CharacterLive, character_id))
    end
  end
end
