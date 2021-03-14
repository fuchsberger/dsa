defmodule DsaWeb.GroupController do
  use DsaWeb, :controller

  alias Dsa.Accounts

  action_fallback DsaWeb.ErrorController

  def new(conn, _params) do
    conn
    |> assign(:changeset, Accounts.change_group(%Accounts.Group{}))
    |> render("new.html")
  end

  def create(conn, %{"group" => group_params}) do
    case Accounts.create_group(group_params) do
      {:ok, _group} ->
        conn
        |> put_flash(:info, gettext("Group was created."))
        |> redirect(to: group_params["redirect"])

      {:error, _changeset} ->
        conn
        |> put_flash(:error, gettext("Group name was invalid."))
        |> redirect(to: group_params["redirect"])
    end
  end

  def join(conn, %{"id" => id}) do
    with group <- Accounts.get_group!(id),
      {:ok, _user} <- Accounts.join_group(conn.assigns.current_user, group)
    do
      conn
      |> put_flash(:info, gettext("You have joined the group."))
      |> redirect(to: Routes.character_path(conn, :index))
    end
  end

  @doc """
  Allows a user to leave a group
  """
  def leave(conn, _parms) do
    with {:ok, user} <- Accounts.leave_group(conn.assigns.current_user) do
      conn
      |> put_flash(:info, gettext("You have left the group."))
      |> redirect(to: Routes.user_path(conn, :edit, user))
    end
  end
end
