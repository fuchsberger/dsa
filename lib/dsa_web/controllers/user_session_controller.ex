defmodule DsaWeb.UserSessionController do
  use DsaWeb, :controller

  alias Dsa.Accounts
  alias DsaWeb.UserAuth

  def new(conn, _params) do
    conn
    |> put_layout("flipped.html")
    |> render("new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      conn
      |> put_layout("flipped.html")
      |> render("new.html", error_message: gettext("Invalid email or password"))
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, gettext("Logged out successfully."))
    |> UserAuth.log_out_user()
  end
end
