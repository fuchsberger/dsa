defmodule DsaWeb.UserSessionController do
  use DsaWeb, :controller

  import DsaWeb.AccountTranslations

  alias Dsa.Accounts
  alias DsaWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      # TODO: Check for account confirmation first
      UserAuth.log_in_user(conn, user, user_params)
    else
      render(conn, "new.html", error_message: t(:invalid_email_or_password))
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, t(:logged_out))
    |> UserAuth.log_out_user()
  end
end
