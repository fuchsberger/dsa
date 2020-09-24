defmodule DsaWeb.LiveHelpers do

  import Phoenix.LiveView

  alias Dsa.Accounts

  require Logger

  @doc """
  Assigns current user to socket when mounting live views.
  Ensure this is done before any other assigns that require the user.
  """
  def assign_defaults(%{"user_id" => user_id} = _session, socket) do
    socket = assign_new(socket, :current_user, fn -> Accounts.get_user!(user_id) end)

    if socket.assigns.current_user do
      socket
    else
      redirect(socket, to: "/login")
    end
  end
end
