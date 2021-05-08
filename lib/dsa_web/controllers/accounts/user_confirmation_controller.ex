defmodule DsaWeb.UserConfirmationController do
  use DsaWeb, :controller

  alias Dsa.Accounts

  def new(conn, _params) do
    conn
    |> put_layout("flipped.html")
    |> render("new.html")
  end

  def create(conn, %{"user_credential" => %{"email" => email}}) do
    if credential = Accounts.get_credential_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        credential,
        &Routes.user_confirmation_url(conn, :confirm, &1))
    end

    # Regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(:info, dgettext("account", "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."))
    |> redirect(to: "/")
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def confirm(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, dgettext("account", "User confirmed successfully."))
        |> redirect(to: "/")

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        confirmed_at =
          case conn.assigns.current_user do
            nil ->
              nil
            user ->
              user
              |> Dsa.Repo.preload(:credential)
              |> Map.get(:credential)
              |> Map.get(:confirmed_at)
          end

        case confirmed_at do
          nil ->
            conn
            |> put_flash(:error,
                  dgettext("account", "User confirmation link is invalid or it has expired."))
            |> redirect(to: "/")

          confirmed_at ->
            redirect(conn, to: "/")
        end
    end
  end
end
