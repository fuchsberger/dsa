defmodule DsaWeb.SessionController do
  use DsaWeb, :controller

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case Dsa.Accounts.authenticate_by_email_and_pass(email, pass) do
      {:ok, user} ->
        conn
        |> DsaWeb.Auth.login(user)
        |> redirect(to: Routes.dsa_path(conn, :dashboard))

      {:error, :unconfirmed, email} ->
        redirect(conn, to: Routes.dsa_path(conn, :confirm, email: email))

      {:error, _reason} ->
        redirect(conn, to: Routes.dsa_path(conn, :login, error: "Ungültige Logindaten."))
    end
  end

  def delete(conn, _) do
    conn
    |> DsaWeb.Auth.logout()
    |> redirect(to: Routes.dsa_path(conn, :login))
  end
end
