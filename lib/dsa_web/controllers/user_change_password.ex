defmodule DsaWeb.UserChangePasswordController do
  use DsaWeb, :controller

  alias Dsa.Accounts

  def edit(conn, _params) do
    conn
    |> put_layout("flipped.html")
    |> render("edit.html", changeset: Accounts.change_user_password(conn.assigns.current_user))
  end

  def update(conn, %{"current_password" => password, "user" => user_params}) do
    case Accounts.update_user_password(conn.assigns.current_user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Password updated successfully."))
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        conn
        |> put_layout("flipped.html")
        |> render("edit.html", changeset: changeset)
    end
  end
end
