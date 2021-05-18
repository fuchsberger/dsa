defmodule DsaWeb.PageController do
  use DsaWeb, :controller

  @doc """
  Home redircts to group page (if logged in and group) or group list (if logged in) or login page
  """
  def index(conn, _) do
    case conn.assigns.current_user do
      nil ->              redirect(conn, to: Routes.user_session_path(conn, :new))
      %{group_id: nil} -> redirect(conn, to: Routes.group_path(conn, :index))
      %{group_id: id} ->  redirect(conn, to: Routes.group_path(conn, :show, id))
    end
  end
end
