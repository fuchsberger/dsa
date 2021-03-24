defmodule DsaWeb.LogLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  def broadcast(group_id, message) do
    Phoenix.PubSub.broadcast!(Dsa.PubSub, topic(group_id), message)
  end

  def topic(group_id), do: "log:#{group_id}"

  def render(assigns), do: Phoenix.View.render(DsaWeb.LogView, "index.html", assigns)

  def mount(_params, %{"group_id" => group_id}, socket) do
    limit = 20
    entries = Dsa.Event.list(group_id)

    # Listens for events
    DsaWeb.Endpoint.subscribe(topic(group_id))

    {:ok, socket
    |> assign(:changeset, Dsa.UI.change_logsetting())
    |> assign(:group_id, group_id)
    |> assign(:entries, entries)
    |> assign(:limit, limit)
    |> assign(:log_empty?, Enum.count(entries) == 0)
    |> assign(:log_resetcount, 0)
    |> assign(:show_dice?, true),
    temporary_assigns: [entries: []]}
  end

  @doc """
  Completely refreshes the log for all concurrent users
  TODO: make more efficient
  """
  def handle_info(:reload, socket) do
    entries = Dsa.Event.list(socket.assigns.group_id)

    {:noreply, socket
    |> assign(:entries, entries)
    |> assign(:log_empty?, Enum.count(entries) == 0)
    |> assign(:log_resetcount, socket.assigns.log_resetcount + 1)}
  end

  def handle_info({:log, entry}, socket) do
    {:noreply, socket
    |> assign(:entries, [entry])
    |> assign(:log_empty?, false)}
  end

  def handle_info(:clear_logs, socket) do
    {:noreply, socket
    |> assign(:entries, [])
    |> assign(:log_empty?, true)
    |> assign(:log_resetcount, socket.assigns.log_resetcount + 1)}
  end

  def handle_event("change", %{"log_setting" => params}, socket) do
    changeset = Dsa.UI.change_logsetting(params)
    entries = Dsa.Event.list(socket.assigns.group_id)

    {:noreply, socket
    |> assign(:changeset, changeset)
    |> assign(:show_dice?, Ecto.Changeset.get_field(changeset, :dice))
    |> assign(:entries, entries)
    |> assign(:log_empty?, Enum.count(entries) == 0)
    |> assign(:log_resetcount, socket.assigns.log_resetcount + 1)}
  end

  def handle_event("clear-log", _params, socket) do
    Dsa.Event.delete_logs!(socket.assigns.group_id)
    broadcast(socket.assigns.group_id, :clear_logs)
    {:noreply, socket}
  end
end
