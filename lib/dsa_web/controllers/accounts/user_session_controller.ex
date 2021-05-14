defmodule DsaWeb.UserSessionController do
  use DsaWeb, :controller

  alias Dsa.Accounts
  alias DsaWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"credential" => credential_params}) do
    %{"email" => email, "password" => password} = credential_params

    if credential = Accounts.get_credential_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, credential, credential_params)
    else
      render(conn, "new.html", error_message: dgettext("account", "Invalid email or password"))
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, dgettext("account", "Logged out successfully."))
    |> UserAuth.log_out_user()
  end
end
