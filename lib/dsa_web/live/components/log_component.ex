defmodule DsaWeb.LogComponent do

  use DsaWeb, :live_component

  import Phoenix.HTML.Tag, only: [content_tag: 3]
  import DsaWeb.DsaLive, only: [topic: 0]

  @group_id 1

  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset, "#", phx_change: :change, phx_submit: nil, phx_target: @myself %>
      <div class='my-2 flex justify-between'>
        <button phx-click="clear-log" phx-target="<%= @myself %>" type="button" class="bg-white py-1 px-3 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 mr-2 lg:mr-3">Log leeren</button>
        <div class="flex items-center align-middle">
          <%= checkbox f, :dice, class: "focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded mr-1", phx_change: :toggle %>
          <%= label f, :dice, "Würfel", class: "font-medium text-gray-700" %>
          <%= checkbox f, :result, class: "focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded ml-4 mr-1", phx_change: :toggle %>
          <%= label f, :result, "Ergebnis", class: "font-medium text-gray-700" %>
        </div>
      </div>
      <div id='log-<%= @log_resetcount %>' phx-update='prepend'>
        <%= for entry <- @entries do %>
          <div id='log-<%= entry.id %>' class='rounded-md bg-white shadow-md my-2 py-1 px-2 flex justify-between'>
            <%= case entry.type do %>
              <% 1 -> %>
                <%# Quickroll %>
                <div class='mr-3'>
                  <span class='inline-block text-xs font-semibold leading-6 px-1 rounded text-blue-500 bg-blue-50 border border-blue-200'><%= entry.character %></span>
                  <span class='mx-1 lg:mx-2'>»</span>
                  <span class='inline-block text-xs font-semibold leading-6 px-1 rounded bg-yellow-50 text-yellow-600 border border-yellow-200'>
                    <%= if entry.x11 > 1, do: entry.x11 %>W<%= entry.x10 %>
                    <%=
                      cond do
                        entry.x9 == 0 -> nil
                        entry.x9 > 0 -> "+ #{entry.x9}"
                        true -> "- #{abs(entry.x9)}"
                      end
                    %>
                  </span>
                </div>
                <div class='flex'>
                  <%= if input_value(f, :dice) do %>
                    <%= tag :dice, entry.x1 %>
                    <%= if entry.x11 >= 2, do: tag(:dice, entry.x2) %>
                    <%= if entry.x11 >= 3, do: tag(:dice, entry.x3) %>
                    <%= if entry.x11 >= 4, do: tag(:dice, entry.x4) %>
                    <%= if entry.x11 >= 5, do: tag(:dice, entry.x5) %>
                    <%= if entry.x11 >= 6, do: tag(:dice, entry.x6) %>
                    <%= if entry.x11 >= 7, do: tag(:dice, entry.x7) %>
                    <%= if entry.x11 == 8, do: tag(:dice, entry.x8) %>
                    <%= if input_value(f, :result), do: separator() %>
                  <% end %>
                  <%= if input_value(f, :result), do: tag(:text, entry.x12) %>
                </div>

              <% 2 -> %>
                <div class='mr-3'>
                  <span class='inline-block text-xs font-semibold leading-6 px-1 rounded text-blue-500 bg-blue-50 border border-blue-200'><%= entry.character %></span>
                  <span class='mx-1 lg:mx-2'>»</span>
                  <span class='inline-block text-xs font-semibold leading-6 px-1 rounded bg-yellow-50 text-yellow-600 border border-yellow-200'>
                    <%= trait(entry.x1) %><%=
                      cond do
                        entry.x3 == 0 -> nil
                        entry.x3 > 0 -> "+#{entry.x3}"
                        true -> "-#{abs(entry.x3)}"
                      end
                    %>
                  </span>
                </div>

                <div class='flex'>
                  <%= if input_value(f, :dice) do %>
                    <%= tag :dice, entry.x4 %>
                    <%= if entry.x4 == 1 || entry.x4 == 20, do: tag(:dice, entry.x5) %>
                    <%= if input_value(f, :result), do: separator() %>
                  <% end %>
                  <%= if input_value(f, :result), do: result_tag(:trait, entry.x12) %>
                </div>

              <% 3 -> %>
                <div class='mr-3'>
                  <span class='inline-block text-xs font-semibold leading-6 px-1 rounded text-blue-500 bg-blue-50 border border-blue-200'><%= entry.character %></span>
                  <span class='mx-1 lg:mx-2'>»</span>
                  <span class='inline-block text-xs font-semibold leading-6 px-1 rounded bg-yellow-50 text-yellow-600 border border-yellow-200'>
                    <%= "#{trait(entry.x1)}/#{trait(entry.x2)}/#{trait(entry.x3)}" %>
                    <%=
                      cond do
                        entry.x10 == 0 -> nil
                        entry.x10 > 0 -> "+ #{entry.x10}"
                        true -> "- #{abs(entry.x10)}"
                      end
                    %>
                  </span>
                </div>
                <div class='flex'>
                  <%= if input_value(f, :dice) do %>
                    <%= tag :dice, entry.x7 %>
                    <%= tag :dice, entry.x8 %>
                    <%= tag :dice, entry.x9 %>
                    <%= if input_value(f, :result), do: separator() %>
                  <% end %>
                  <%= if input_value(f, :result), do: result_tag(:talent, entry.x12) %>
                </div>

              <% _ -> %> Unbekannter Logeintrag
            <% end %>
          </div>
        <% end %>
      </div>

      <div class='rounded-md bg-white shadow-md my-2 p-1 text-center<%= unless @log_empty?, do: " hidden" %>'>
        Bei Phex! Noch sind keine Würfel gerollt!
      </div>
    </form>
    """
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

  defp modifier(value) do
    cond do
      value < 0 -> label(:red, value)
      value > 0 -> label(:green, value)
      true -> nil
    end
  end

  defp trait(index), do: Enum.at(~w(MU KL IN CH GE FF KO KK), index)

  defp separator, do: content_tag(:span, "»", class: "inline-block align-middle mx-1 lg:mx-2")

  import Phoenix.HTML.Tag, except: [tag: 2]

  @base "inline-block font-semibold leading-6 px-1 rounded"

  defp tag(:blue, c), do: content_tag :span, c,
    class: "#{@base} text-blue-500 bg-blue-50 border border-blue-200"

  defp tag(:green, c), do: content_tag :span, c, class: "#{@base} bg-green-50 text-green-500"

  defp tag(:red, c), do: content_tag :span, c, class: "#{@base} bg-red-50 text-red-500"

  defp tag(:yellow, c), do: content_tag :span, c,
    class: "#{@base} bg-yellow-50 text-yellow-600 border border-yellow-200"

  defp tag(:dice, c), do: content_tag :span, c,
    class: "#{@base} text-gray-500 border border-md border-gray-300 bg-gray-100 w-6 ml-1 text-center"

  defp tag(:text, c), do: content_tag :span, c, class: "leading-6 font-bold text-gray-900"

  defp separator, do: content_tag(:span, "»", class: "leading-6 mx-1 lg:mx-2")

  defp result_tag(:trait, value) do
    case value do
      2 -> content_tag :span, "✓ K!", class: "#{@base} bg-green-50 text-green-500"
      1 -> content_tag :span, "✓", class: "#{@base} bg-green-50 text-green-500"
      -1 -> content_tag :span, "✗", class: "#{@base} bg-red-50 text-red-500"
      -2 -> content_tag :span, "✗ K!", class: "#{@base} bg-red-50 text-red-500"
      nil -> "Error"
    end
  end

  defp result_tag(:talent, value) do
    case value do
      10 -> content_tag :span, "✓ K!", class: "#{@base} bg-green-50 text-green-500"
      -2 -> content_tag :span, "✗ K!", class: "#{@base} bg-red-50 text-red-500"
      -1 -> content_tag :span, "✗", class: "#{@base} bg-red-50 text-red-500"
      x -> content_tag :span, "✓ #{x}", class: "#{@base} bg-green-50 text-green-500"
      nil -> "Error"
    end
  end
end
