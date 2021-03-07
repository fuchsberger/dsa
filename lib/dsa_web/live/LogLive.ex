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

  # def render(assigns) do
  #   ~L"""
  #   <div class='mb-2 flex justify-between'>
  #     <button type="button" phx-click="clear-log"  class="bg-white py-1 px-3 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 mr-2 lg:mr-3">Log leeren</button>
  #     <div class="hidden flex items-center align-middle">
  #       <%# checkbox f, :dice, class: "focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded mr-1", phx_change: :toggle %>
  #       <%# label f, :dice, "Würfel", class: "font-medium text-gray-700" %>
  #       <%# checkbox f, :result, class: "focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded ml-4 mr-1", phx_change: :toggle %>
  #       <%# label f, :result, "Ergebnis", class: "font-medium text-gray-700" %>
  #     </div>
  #   </div>

  #   <%= if @log_empty? do %>
  #     <div class='rounded-md bg-white shadow-md my-2 p-1 text-center'><%= gettext "Bei Phex! Noch sind keine Würfel gerollt!" %></div>
  #   <% else %>
  #     <div id='log-entries' phx-update='prepend'>
  #       <%= for entry <- @entries do %>
  #         <div id='log-<%= entry.id %>' class='rounded-md bg-white shadow-md my-2 py-1 px-2 flex justify-between'>
  #           <%= case entry.type do %>
  #             <% 1 -> %>
  #               <%# Quickroll %>
  #               <div class='mr-3'>
  #                 <span class='inline-block text-xs font-semibold leading-6 px-1 rounded text-blue-500 bg-blue-50 border border-blue-200'><%= entry.character %></span>
  #                 <span class='mx-1 lg:mx-2'>»</span>
  #                 <span class='inline-block text-xs font-semibold leading-6 px-1 rounded bg-yellow-50 text-yellow-600 border border-yellow-200'>
  #                   <%= if entry.x11 > 1, do: entry.x11 %>W<%= entry.x10 %>
  #                   <%=
  #                     cond do
  #                       entry.x9 == 0 -> nil
  #                       entry.x9 > 0 -> "+ #{entry.x9}"
  #                       true -> "- #{abs(entry.x9)}"
  #                     end
  #                   %>
  #                 </span>
  #               </div>
  #               <div class='flex'>
  #                 <%= tag :dice, entry.x1 %>
  #                 <%= if entry.x11 >= 2, do: clabel(:dice, entry.x2) %>
  #                 <%= if entry.x11 >= 3, do: clabel(:dice, entry.x3) %>
  #                 <%= if entry.x11 >= 4, do: clabel(:dice, entry.x4) %>
  #                 <%= if entry.x11 >= 5, do: clabel(:dice, entry.x5) %>
  #                 <%= if entry.x11 >= 6, do: clabel(:dice, entry.x6) %>
  #                 <%= if entry.x11 >= 7, do: clabel(:dice, entry.x7) %>
  #                 <%= if entry.x11 == 8, do: clabel(:dice, entry.x8) %>
  #                 <%= separator() %>
  #                 <%= clabel(:text, entry.x12) %>
  #               </div>

  #             <% 2 -> %>
  #               <div class='mr-3'>
  #                 <span class='inline-block text-xs font-semibold leading-6 px-1 rounded text-blue-500 bg-blue-50 border border-blue-200'><%= entry.character %></span>
  #                 <span class='mx-1 lg:mx-2'>»</span>
  #                 <span class='inline-block text-xs font-semibold leading-6 px-1 rounded bg-yellow-50 text-yellow-600 border border-yellow-200'>
  #                   <%= trait(entry.x1) %><%=
  #                     cond do
  #                       entry.x3 == 0 -> nil
  #                       entry.x3 > 0 -> "+#{entry.x3}"
  #                       true -> "-#{abs(entry.x3)}"
  #                     end
  #                   %>
  #                 </span>
  #               </div>

  #               <div class='flex'>
  #                 <%= tag :dice, entry.x4 %>
  #                 <%= if entry.x4 == 1 || entry.x4 == 20, do: clabel(:dice, entry.x5) %>
  #                 <%= separator() %>
  #                 <%= result_clabel(:trait, entry.x12) %>
  #               </div>

  #             <% 3 -> %>
  #               <div class='mr-3'>
  #                 <span class='inline-block text-xs font-semibold leading-6 px-1 rounded text-blue-500 bg-blue-50 border border-blue-200'><%= entry.character %></span>
  #                 <span class='mx-1 lg:mx-2'>»</span>
  #                 <span class='inline-block text-xs font-semibold leading-6 px-1 rounded bg-yellow-50 text-yellow-600 border border-yellow-200'>
  #                   <%= "#{trait(entry.x1)}/#{trait(entry.x2)}/#{trait(entry.x3)}" %>
  #                   <%=
  #                     cond do
  #                       entry.x10 == 0 -> nil
  #                       entry.x10 > 0 -> "+ #{entry.x10}"
  #                       true -> "- #{abs(entry.x10)}"
  #                     end
  #                   %>
  #                 </span>
  #               </div>
  #               <div class='flex'>
  #                 <%= clabel :dice, entry.x7 %>
  #                 <%= clabel :dice, entry.x8 %>
  #                 <%= clabel :dice, entry.x9 %>
  #                 <%= separator() %>
  #                 <%= result_clabel(:talent, entry.x12) %>
  #               </div>

  #             <% 4 -> %>
  #               <%# Skill Roll %>
  #               <div class='mr-3'>
  #                 <span class='inline-block text-xs font-semibold leading-6 px-1 rounded text-blue-500 bg-blue-50 border border-blue-200'><%= entry.character %></span>
  #                 <span class='mx-1 lg:mx-2'>»</span>
  #                 <span class='inline-block text-xs font-semibold leading-6 px-1 rounded bg-yellow-50 text-yellow-600 border border-yellow-200'>
  #                   <%= Skill.name(entry.x1) %>
  #                   <%=
  #                     cond do
  #                       entry.x10 == 0 -> nil
  #                       entry.x10 > 0 -> "+#{entry.x10}"
  #                       true -> entry.x10
  #                     end
  #                   %>
  #                 </span>
  #               </div>
  #               <div class='flex'>
  #                 <%= clabel :dice, entry.x7 %>
  #                 <%= clabel :dice, entry.x8 %>
  #                 <%= clabel :dice, entry.x9 %>
  #                 <%= separator() %>
  #                 <%= result_clabel(:talent, entry.x12) %>
  #               </div>
  #             <% 5 -> %>
  #               <%# Spell Roll %>
  #               <div class='mr-3'>
  #                 <span class='inline-block text-xs font-semibold leading-6 px-1 rounded text-blue-500 bg-blue-50 border border-blue-200'><%= entry.character %></span>
  #                 <span class='mx-1 lg:mx-2'>»</span>
  #                 <span class='inline-block text-xs font-semibold leading-6 px-1 rounded bg-yellow-50 text-yellow-600 border border-yellow-200'>
  #                   <%= Spell.name(entry.x1) %>
  #                   <%=
  #                     cond do
  #                       entry.x10 == 0 -> nil
  #                       entry.x10 > 0 -> "+#{entry.x10}"
  #                       true -> entry.x10
  #                     end
  #                   %>
  #                 </span>
  #               </div>
  #               <div class='flex'>
  #                 <%= tag :dice, entry.x7 %>
  #                 <%= tag :dice, entry.x8 %>
  #                 <%= tag :dice, entry.x9 %>
  #                 <%= separator() %>
  #                 <%= result_clabel(:talent, entry.x12) %>
  #               </div>

  #             <% _ -> %>
  #               <%= gettext "Unbekannter Logeintrag" %>
  #           <% end %>
  #         </div>
  #       <% end %>
  #     </div>
  #   <% end %>
  #   """
  # end

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

  def handle_event("clear-log", _params, socket) do
    case Dsa.Event.delete_logs(socket.assigns.group_id) do
      {0, _} ->
        Logger.warn("No log entries exist for deleting.")
        {:noreply, socket}

      {count, _} ->
        Logger.warn("#{count} log entries deleted.")
        broadcast(socket.assigns.group_id, :clear_logs)
        {:noreply, socket}
    end
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
