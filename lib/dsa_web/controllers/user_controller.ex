defmodule DsaWeb.UserController do
  use DsaWeb, :controller

  alias Dsa.Accounts

  def edit_password(conn, _) do
    changeset = Accounts.change_password(conn.assigns.current_user)
    render(conn, "edit_password.html", changeset: changeset)
  end

  def change_password(conn, %{"user" => params}) do
    changeset = Accounts.change_password(conn.assigns.current_user, params)

    case Accounts.update_user(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Passwort geändert!")
        |> redirect(to: Routes.character_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Etwas ist schiefgelaufen")
        |> render("edit_password.html", changeset: changeset)
    end
  end
end
