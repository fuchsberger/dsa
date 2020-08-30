defmodule DsaWeb.SessionController do
  use DsaWeb, :controller

  def index(conn, _) do
    if is_nil(conn.assigns.current_user),
      do: redirect(conn, to: Routes.session_path(conn, :new)),
      else: redirect(conn, to: Routes.group_path(conn, :roll, 1))
  end

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    case Dsa.Accounts.authenticate_by_username_and_pass(username, pass) do
      {:ok, user} ->
        conn
        |> DsaWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.group_path(conn, :roll, 1))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> DsaWeb.Auth.logout()
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
