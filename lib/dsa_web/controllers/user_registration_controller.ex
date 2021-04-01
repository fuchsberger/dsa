defmodule DsaWeb.UserRegistrationController do
  use DsaWeb, :controller

  alias Dsa.Accounts
  alias Dsa.Accounts.User
  alias DsaWeb.UserAuth

  def new(conn, _params) do
    conn
    |> put_layout("flipped.html")
    |> render("new.html", changeset: Accounts.change_user_registration(%User{}))
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, gettext("User created successfully."))
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
