defmodule DsaWeb.UserController do
  use DsaWeb, :controller

  alias Dsa.{Accounts, Email, Mailer}
  alias Dsa.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_registration(%User{}, %{})

    conn
    |> put_layout("wide.html")
    |> render("new.html", changeset: changeset)
  end

  def confirm(conn, %{"token" => token}) do
    #TODO
    conn
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->

        user
        |> Email.confirmation_email()
        |> Mailer.deliver_now()

        conn
        |> put_flash(:info, gettext("Account created! An email to activate your account was sent."))
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_layout("wide.html")
        |> render("new.html", changeset: changeset)
    end
  end
end
