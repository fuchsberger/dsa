defmodule DsaWeb.UserRegistrationController do
  use DsaWeb, :controller

  alias Dsa.Accounts
  alias Dsa.Accounts.UserCredential
  alias DsaWeb.UserAuth

  def new(conn, _params) do
    conn
    |> put_layout("flipped.html")
    |> render("new.html", changeset: Accounts.change_user_registration(%UserCredential{}))
  end

  def create(conn, %{"user_credential" => credential_params}) do
    case Accounts.register_user(credential_params) do
      {:ok, credential} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            credential,
            &Routes.user_confirmation_url(conn, :confirm, &1))

        conn
        |> put_flash(:info, dgettext("account", "User created successfully."))
        |> UserAuth.log_in_user(credential)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_layout("flipped.html")
        |> render("new.html", changeset: changeset)
    end
  end
end
