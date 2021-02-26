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
    case Accounts.get_user_by(confirmed: false, token: token) do
      nil ->
        conn
        |> put_flash(:error, gettext("The link is invalid or expired."))
        |> redirect(to: Routes.session_path(conn, :new))

      user ->
        user = Accounts.manage_user!(user, %{confirmed: true, token: nil})

        conn
        |> DsaWeb.Auth.login(user)
        |> put_flash(:info, "Activation complete. Welcome to DSA Tool!")
        |> redirect(to: Routes.dsa_path(conn, :dashboard))
    end
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

  def reset(conn, _params) do
    conn
    |> put_layout("wide.html")
    |> render("reset.html", changeset: Accounts.change_email(%{}))
  end

  def send_reset_link(conn, %{"user" => %{"email" => email} = params}) do
    case Accounts.get_user_by(email: email) do
      nil ->
        Pbkdf2.no_user_verify()
        conn
        |> put_flash(:error, gettext("The given email is not registered."))
        |> put_layout("wide.html")
        |> render("reset.html", changeset: Accounts.change_email(params))

      user ->
        user
        |> Accounts.manage_user!(%{reset: true, token: Accounts.User.token()})
        |> Email.reset_email()
        |> Mailer.deliver_now()

        conn
        |> put_flash(:info, gettext("A link to reset your password was sent to the email."))
        |> put_layout("wide.html")
        |> render("reset.html", changeset: Accounts.change_email(params))
    end
  end

  def reset_password(conn, %{"token" => token}) do
    case Accounts.get_user_by(reset: true, token: token) do
      nil ->
        conn
        |> put_flash(:error, gettext("The link is invalid or expired."))
        |> redirect(to: Routes.session_path(conn, :new))

      user ->
        changeset = Accounts.change_password(user, %{})

        conn
        |> put_layout("wide.html")
        |> render("reset_password.html", changeset: changeset, token: token)
    end
  end

  def update_password(conn, %{"token" => token, "user" => user_params}) do
    Logger.warn(inspect (user_params))
    case Accounts.get_user_by(reset: true, token: token) do
      nil ->
        conn
        |> put_flash(:error, gettext("The link is invalid or expired."))
        |> redirect(to: Routes.session_path(conn, :new))

      user ->
        case Accounts.update_password(user, user_params) do
          {:ok, user} ->
            Accounts.manage_user!(user, %{reset: false, token: nil})

            conn
            |> DsaWeb.Auth.login(user)
            |> put_flash(:info, gettext("Password successfully reset. Welcome back!"))
            |> redirect(to: Routes.dsa_path(conn, :dashboard))

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_layout("wide.html")
            |> render("reset_password.html", changeset: changeset, token: token)
        end
    end
  end
end
