defmodule DsaWeb.SessionController do
  use DsaWeb, :controller

  def new(conn, _) do
    conn
    |> put_layout("wide.html")
    |> render("new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case Dsa.Accounts.authenticate_by_email_and_pass(email, pass) do
      {:ok, user} ->
        conn
        |> DsaWeb.Auth.login(user)
        |> redirect(to: Routes.dsa_path(conn, :dashboard))

      {:error, :unconfirmed, email} ->
        redirect(conn, to: Routes.dsa_path(conn, :confirm, email: email))

      {:error, _reason} ->
        conn
        |> put_flash(:error, gettext("Invalid Login Data"))
        |> put_layout("wide.html")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> DsaWeb.Auth.logout()
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
