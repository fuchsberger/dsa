defmodule DsaWeb.UserRegistrationController do
  use DsaWeb, :controller

  alias Dsa.Accounts
  alias Dsa.Accounts.UserCredential
  alias DsaWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", changeset: Accounts.change_user_registration(%UserCredential{}))
  end

  def create(conn, %{"user_credential" => credential_params}) do
    case Accounts.register_user(credential_params) do
      {:ok, credential} ->
        %Bamboo.Email{to: [nil: email]} =
          Accounts.deliver_user_confirmation_instructions(
            credential,
            &Routes.user_confirmation_url(conn, :confirm, &1))

        conn
        |> put_flash(:success, dgettext("account", "Registration successfull! A link to activate your account was sent to %{email}.", email: email))
        # |> UserAuth.log_in_user(credential)
        |> redirect(to: Routes.user_session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
