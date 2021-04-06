defmodule DsaWeb.UserSettingsController do
  use DsaWeb, :controller

  alias Dsa.Accounts
  alias DsaWeb.UserAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    conn
    |> put_layout("flipped.html")
    |> render("edit.html")
  end

  def update(conn, %{"current_password" => password, "user" => user_params}) do
    case Accounts.apply_user_email(conn.assigns.current_user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          conn.assigns.current_user.email,
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(:info, gettext("A link to confirm your email change has been sent to the new address."))
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    assign(conn, :email_changeset, Accounts.change_user_email(conn.assigns.current_user))
  end
end
