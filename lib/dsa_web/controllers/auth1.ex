defmodule DsaWeb.Auth do

  import Plug.Conn
  import Phoenix.Controller
  import DsaWeb.Gettext

  alias Dsa.Accounts
  alias DsaWeb.Router.Helpers, as: Routes
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      conn.assigns[:current_user] -> conn
      user = user_id && Accounts.get_user(user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  @doc """
  Results in a redirect to login if the user is not authenticated.
  Further, if a user is authenticated but without group, assign groups and group changeset.
  """
  def authenticate_user(conn, _opts \\ []) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, gettext("You must be logged in to access this page."))
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end

  def match_user_id(conn, id) do
    case conn.assigns do
      %{current_user: nil} ->
        {:error, :unauthorized}

      %{current_user: user} ->
        if user.id == String.to_integer(id), do: :ok, else: {:error, :forbidden}
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
