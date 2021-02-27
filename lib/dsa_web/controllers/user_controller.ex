defmodule DsaWeb.UserController do
  use DsaWeb, :controller

  alias Dsa.{Accounts, Email, Mailer}
  alias Dsa.Accounts.User

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def new(conn, _params, _current_user) do
    changeset = Accounts.change_registration(%User{}, %{})

    conn
    |> put_layout("wide.html")
    |> render("new.html", changeset: changeset)
  end

  def confirm(conn, %{"token" => token}, _current_user) do
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
        |> redirect(to: Routes.character_path(conn, :index))
    end
  end

  def create(conn, %{"user" => user_params}, _current_user) do
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

  def edit(conn, _params, current_user) do
    changeset = Accounts.change_user(current_user, %{})
    group_options = Accounts.list_group_options()

    conn
    |> render("edit.html", changeset: changeset, options: group_options)
  end

  def update(conn, %{"user" => user_params}, current_user) do
    case Accounts.update_user(current_user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: Routes.character_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        group_options = Accounts.list_group_options()
        render(conn, "edit.html", changeset: changeset, options: group_options)
    end
  end

  def delete(conn, _params, current_user) do
    {:ok, _user} = Accounts.delete_user(current_user)

    conn
    |> DsaWeb.Auth.logout()
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: Routes.session_path(conn, :new))
  end

  def reset(conn, _params, _current_user) do
    conn
    |> put_layout("wide.html")
    |> render("reset.html", changeset: Accounts.change_email(%{}))
  end

  def send_reset_link(conn, %{"user" => %{"email" => email} = params}, _current_user) do
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

  def reset_password(conn, %{"token" => token}, _current_user) do
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

  def update_password(conn, %{"token" => token, "user" => user_params}, _current_user) do
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
            |> redirect(to: Routes.character_path(conn, :index))

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_layout("wide.html")
            |> render("reset_password.html", changeset: changeset, token: token)
        end
    end
  end
end
