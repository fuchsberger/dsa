defmodule DsaWeb.UserSessionController do
  use DsaWeb, :controller

  import DsaWeb.AccountTranslations

  alias Dsa.Accounts
  alias DsaWeb.UserAuth

  def new(conn, _params) do
    Logger.warn Routes.user_confirmation_url(conn, :confirm, "ABC")
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do

    %{"email" => email, "password" => password} = user_params

    with {:ok, user} <- Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      {:error, :bad_username_or_password} ->
        render(conn, "new.html", error_message: t(:invalid_email_or_password))

      {:error, :user_blocked} ->
        render(conn, "new.html", error_message: t(:blocked_message))

      {:error, :not_confirmed} ->
        user = Accounts.get_user_by_email(email)

        Accounts.deliver_user_confirmation_instructions(user,
          &Routes.user_confirmation_url(conn, :confirm, &1))

        render(conn, "new.html", error_message: t(:confirm_before_signin))
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, t(:logged_out))
    |> UserAuth.log_out_user()
  end
end
