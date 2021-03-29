defmodule DsaWeb.SessionController do
  use DsaWeb, :controller

  import DsaWeb.Auth, only: [match_user_id: 2]

  action_fallback DsaWeb.ErrorController

  @doc """
  Home redircts to group page (if logged in and group) or group list (if logged in) or login page
  """
  def index(conn, _) do
    case conn.assigns.current_user do
      nil ->              redirect(conn, to: Routes.session_path(conn, :new))
      %{group_id: nil} -> redirect(conn, to: Routes.group_path(conn, :index))
      %{group_id: id} ->  redirect(conn, to: Routes.group_path(conn, :show, id))
    end
  end

  def new(conn, _) do
    if conn.assigns.current_user do
      redirect(conn, to: Routes.character_path(conn, :index))
    else
      conn
      |> put_layout("flipped.html")
      |> render("new.html")
    end
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    with {:ok, user} <- Dsa.Accounts.authenticate_by_email_and_password(email, pass) do
      conn
      |> DsaWeb.Auth.login(conn, user)
      |> redirect(to: Routes.session_path(conn, :index))
    end
  end

  def delete(conn, %{"user_id" => id}) do
    with :ok <- match_user_id(conn, id) do
      conn
      |> DsaWeb.Auth.logout()
      |> redirect(to: Routes.session_path(conn, :new))
    end
  end
end
