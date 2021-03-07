defmodule DsaWeb.LogLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  import DsaWeb.Gettext

  alias Dsa.Data.{Skill, Spell}

  require Logger

  def broadcast(group_id, message) do
    Phoenix.PubSub.broadcast!(Dsa.PubSub, topic(group_id), message)
  end

  def topic(group_id), do: "log:#{group_id}"

  def render(assigns), do: Phoenix.View.render(DsaWeb.LogView, "index.html", assigns)

  def mount(_params, %{"group_id" => group_id}, socket) do
    entries = Dsa.Event.list_logs(group_id)

    # Listens for events
    DsaWeb.Endpoint.subscribe(topic(group_id))

    {:ok, socket
    |> assign(:changeset, Dsa.UI.change_logsetting())
    |> assign(:group_id, group_id)
    |> assign(:entries, entries)
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
    entries = Dsa.Event.list_logs(socket.assigns.group_id)

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
    entries = Dsa.Event.list_logs(socket.assigns.group_id)

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

  defp trait(index), do: Enum.at(~w(MU KL IN CH GE FF KO KK), index)

  defp separator, do: content_tag(:span, "»", class: "inline-block align-middle mx-1 lg:mx-2")

  import Phoenix.HTML.Tag, except: [tag: 2]

  @base "inline-block font-semibold leading-6 px-1 rounded"

  defp clabel(:blue, c), do: content_tag :span, c,
    class: "#{@base} text-blue-500 bg-blue-50 border border-blue-200"

  defp clabel(:green, c), do: content_tag :span, c, class: "#{@base} bg-green-50 text-green-500"

  defp clabel(:red, c), do: content_tag :span, c, class: "#{@base} bg-red-50 text-red-500"

  defp clabel(:yellow, c), do: content_tag :span, c,
    class: "#{@base} bg-yellow-50 text-yellow-600 border border-yellow-200"

  defp clabel(:dice, c), do: content_tag :span, c,
    class: "#{@base} text-gray-500 border border-md border-gray-300 bg-gray-100 w-6 ml-1 text-center"

  defp clabel(:text, c), do: content_tag :span, c, class: "leading-6 font-bold text-gray-900"

  defp result_clabel(:trait, value) do
    case value do
      2 -> content_tag :span, "✓ K!", class: "#{@base} bg-green-50 text-green-500"
      1 -> content_tag :span, "✓", class: "#{@base} bg-green-50 text-green-500"
      -1 -> content_tag :span, "✗", class: "#{@base} bg-red-50 text-red-500"
      -2 -> content_tag :span, "✗ K!", class: "#{@base} bg-red-50 text-red-500"
    end
  end

  defp result_clabel(:talent, value) do
    case value do
      10 -> content_tag :span, "✓ K!", class: "#{@base} bg-green-50 text-green-500"
      -2 -> content_tag :span, "✗ K!", class: "#{@base} bg-red-50 text-red-500"
      -1 -> content_tag :span, "✗", class: "#{@base} bg-red-50 text-red-500"
      x -> content_tag :span, "✓ #{x}", class: "#{@base} bg-green-50 text-green-500"
    end
  end
end
