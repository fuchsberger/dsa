defmodule DsaWeb.UserChangePasswordController do
  use DsaWeb, :controller

  alias Dsa.Accounts

  plug :assign_credential

  def edit(conn, _params) do
    conn
    |> put_layout("flipped.html")
    |> render("edit.html", changeset: Accounts.change_user_password(conn.assigns.credential))
  end

  def update(conn, %{"current_password" => password, "user_credential" => credential_params}) do
    Logger.warn "UPDATE"
    case Accounts.update_user_password(conn.assigns.credential, password, credential_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, dgettext("account", "Password updated successfully."))
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        conn
        |> put_layout("flipped.html")
        |> render("edit.html", changeset: changeset)
    end
  end

  defp assign_credential(conn, _opts) do
    assign(conn, :credential, Accounts.get_credential(conn.assigns.current_user.id))
  end
end
