defmodule DsaWeb.LogLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Dsa.{Accounts, Logs}

  require Logger

  def broadcast(group_id, message) do
    Phoenix.PubSub.broadcast!(Dsa.PubSub, topic(group_id), message)
  end

  def topic(group_id), do: "log:#{group_id}"

  def render(assigns), do: Phoenix.View.render(DsaWeb.LogView, "index.html", assigns)

  def mount(_params, %{"group_id" => group_id, "user_id" => user_id}, socket) do

    %{master_id: master_id} = Accounts.get_group!(group_id)
    limit = 10
    entries = Logs.list_events(group_id, limit)

    # Listens for events
    DsaWeb.Endpoint.subscribe(topic(group_id))

    {:ok, socket
    |> assign(:changeset, Dsa.UI.change_logsetting())
    |> assign(:group_id, group_id)
    |> assign(:entries, entries)
    |> assign(:limit, limit)
    |> assign(:master?, master_id == user_id)
    |> assign(:show_dice?, true)}
  end

  def handle_info({:log, entry}, socket) do
    entries =
      case Enum.count(socket.assigns.entries) < Ecto.Changeset.get_field(socket.assigns.changeset, :limit) do
        true ->
          [entry | socket.assigns.entries]
        false ->
          {_oldest, entries} = List.pop_at([entry | socket.assigns.entries], -1)
          entries
      end

    {:noreply, assign(socket, :entries, entries)}
  end

  def handle_info(:clear_log, socket) do
    {:noreply, assign(socket, :entries, [])}
  end

  @doc """
  Only change assigns that were changed (performance friendly)
  """
  def handle_event("change", %{"log_setting" => params}, socket) do

    changeset = Dsa.UI.change_logsetting(params)

    socket =
      if Map.has_key?(changeset.changes, :limit) do
        limit = Ecto.Changeset.get_field(changeset, :limit)

        socket
        |> assign(:limit, limit)
        |> assign(:entries, Logs.list_events(socket.assigns.group_id, limit))
      else
        socket
      end

    socket =
      if Map.has_key?(changeset.changes, :dice) do
        assign(socket, :show_dice?, Ecto.Changeset.get_field(changeset, :dice))
      else
        socket
      end

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("clear-log", _params, socket) do
    if socket.assigns.master? do
      Logs.delete_all_events!(socket.assigns.group_id)
      broadcast(socket.assigns.group_id, :clear_log)
    end
    {:noreply, socket}
  end
end
