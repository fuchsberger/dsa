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
    case Accounts.create_group(conn.assigns.current_user, group_params) do
      {:ok, group} ->
        conn
        |> put_flash(:info, gettext("Group was created."))
        |> redirect(to: Routes.group_path(conn, :show, group))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    with group <- Accounts.get_group!(id) do
      render(conn, "show.html", group: group)
    end
  end

  def join(conn, %{"id" => id}) do
    with group <- Accounts.get_group!(id),
      {:ok, _user} <- Accounts.join_group(conn.assigns.current_user, group)
    do
      conn
      |> put_flash(:info, gettext("You have joined the group."))
      |> redirect(to: Routes.group_path(conn, :show, group))
    end
  end

  @doc """
  Allows a user to leave a group
  """
  def leave(conn, _parms) do
    with {:ok, _user} <- Accounts.leave_group(conn.assigns.current_user) do
      conn
      |> put_flash(:info, gettext("You have left the group."))
      |> redirect(to: Routes.character_path(conn, :index))
    end
  end
end
