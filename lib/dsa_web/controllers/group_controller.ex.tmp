defmodule DsaWeb.GroupController do
  use DsaWeb, :controller

  alias Dsa.Accounts

  action_fallback DsaWeb.ErrorController

  def index(conn, _params) do
    conn
    |> assign(:groups, Accounts.list_groups())
    |> render("index.html")
  end

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

  def edit(conn, %{"id" => id}) do
    group = Accounts.get_group!(id)
    conn
    |> assign(:changeset, Accounts.change_group(group))
    |> assign(:group, group)
    |> render("edit.html")
  end

  @doc """
  Allows to delete a group if user is the master or an admin.
  # TODO: change so users can only delete if master or admin
  """
  def delete(conn, %{"id" => id}) do
    with group <- Accounts.get_group!(id),
      {:ok, _group} = Accounts.delete_group(group)
    do
      conn
      |> put_flash(:info, gettext("Group deleted successfully."))
      |> redirect(to: Routes.group_path(conn, :index))
    end
  end

  @doc """
  TODO: if logged in and member of group show group actions.
  Otherwise redirect to groups page, Future: show group without actions (observer mode)
  """
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
  Allows a user to leave a group.
  """
  def leave(conn, _parms) do
    with {:ok, _user} <- Accounts.leave_group(conn.assigns.current_user) do
      conn
      |> put_flash(:info, gettext("You have left the group."))
      |> redirect(to: Routes.group_path(conn, :index))
    end
  end
end
