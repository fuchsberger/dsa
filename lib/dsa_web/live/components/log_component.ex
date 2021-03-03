defmodule DsaWeb.LogComponent do

  use DsaWeb, :live_component

  import DsaWeb.DsaLive, only: [topic: 0]

  @group_id 1

  def render(assigns) do
    Phoenix.View.render DsaWeb.LogView, "index.html", assigns
  end

  def mount(socket) do

    entries = Dsa.Event.list_logs(@group_id)

    {:ok, socket
    |> assign(:changeset, Dsa.UI.change_logsetting())
    |> assign(:entries, entries)
    |> assign(:log_empty?, Enum.count(entries) == 0)
    |> assign(:log_resetcount, 0),
    temporary_assigns: [entries: []]}
  end

  def update(assigns, socket) do
    case Map.get(assigns, :action) do
      nil ->
        {:ok, socket}

      :add ->
        {:ok, socket
        |> assign(:log_empty?, false)
        |> assign(:entries, [Map.get(assigns, :entry)])}

      :clear ->
        {:ok, socket
        |> assign(:log_empty?, true)
        |> assign(:entries, [false]) # forces temporary assign to be treated as updated
        |> assign(:entries, [])
        |> assign(:log_resetcount, socket.assigns.log_resetcount + 1)}
    end
  end

  def handle_info(%{event: "log", payload: log}, socket) do
    {:noreply, socket
    |> assign(:log_empty?, false)
    |> assign(:entries, [log])}
  end

  def handle_event("change", %{"log_setting" => params}, socket) do
    {:noreply, socket
    |> assign(:changeset, Dsa.UI.change_logsetting(params))
    |> assign(:entries, Dsa.Event.list_logs(@group_id))
    |> assign(:log_resetcount, socket.assigns.log_resetcount + 1)}
  end

  def handle_event("clear-log", _params, socket) do
    case Dsa.Event.delete_logs(@group_id) do
      {0, _} ->
        Logger.warn("No log entries exist for deleting.")
        {:noreply, socket}

      {count, _} ->
        Logger.warn("#{count} log entries deleted.")
        Phoenix.PubSub.broadcast!(Dsa.PubSub, topic(), :clear_logs)
        {:noreply, socket}
    end
  end
end
