defmodule DsaWeb.GroupController do
  use DsaWeb, :controller

  import DsaWeb.Auth, only: [match_user_id: 2]

  alias Dsa.Accounts

  action_fallback DsaWeb.ErrorController

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
