defmodule DsaWeb.Auth do

  import Plug.Conn
  import Phoenix.Controller
  import DsaWeb.Gettext

  alias DsaWeb.Router.Helpers, as: Routes
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Dsa.Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, gettext("You must be logged in to access this page."))
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end

  def admin(conn, _opts) do
    if conn.assigns.current_user.admin do
      conn
    else
      conn
      |> put_flash(:error, gettext("You must be an adminstrator to access this page."))
      |> redirect(to: Routes.character_path(conn, :index))
      |> halt()
    end
  end
end
