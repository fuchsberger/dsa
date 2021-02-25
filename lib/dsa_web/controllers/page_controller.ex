defmodule DsaWeb.PageController do
  use DsaWeb, :controller

  def index(conn, _) do
    if is_nil(conn.assigns.current_user) do
      redirect(conn, to: Routes.session_path(conn, :new))
    else
      redirect(conn, to: Routes.dsa_path(conn, :dashboard))
    end
  end
end
