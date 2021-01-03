defmodule LogComponent do

  use Phoenix.LiveComponent
  import Phoenix.HTML.Tag, only: [content_tag: 3]

  def render(assigns) do
    ~L"""
    <div id='log-<%= @entry.id %>' class='rounded-md bg-white shadow-md my-2 py-1 px-2 flex justify-between'>
      <%= case @entry.type do %>
        <% 1 -> %>
          <%= quickroll_1w20(assigns) %>

        <% 2 -> %>
          <div>
            <span class="text-xs font-semibold inline-block py-1 px-2 rounded text-blue-500 bg-blue-50"><%= @entry.character.name %></span> würfelt <span class="text-xs font-semibold inline-block p-1 rounded border border-gray-300 bg-gray-50 text-gray-500">W6</span>
          </div>
          <div>
            <span class="text-xs font-bold inline-block py-1 rounded text-center text-gray-500 border border-gray-300 bg-gray-100 w-6"><%= @entry.x1 %></span>
          </div>

        <% 3 -> %>
          <div>
            <span class="text-xs font-semibold inline-block py-1 px-2 rounded text-blue-500 bg-blue-50"><%= @entry.character.name %></span> würfelt <span class="text-xs font-semibold inline-block p-1 rounded border border-gray-300 bg-gray-50 text-gray-500">2W6</span>
          </div>
          <div>
            <span class="text-xs font-bold inline-block rounded text-center text-gray-500 border border-gray-300 bg-gray-100 w-5 h-5 mr-1"><%= @entry.x1 %></span><span class="text-xs font-bold inline-block rounded text-center text-gray-500 border border-gray-300 bg-gray-100 w-5 h-5"><%= @entry.x2 %></span> »
            <span class="font-extrabold text-gray-900 mr-1"><%= @entry.x1 + @entry.x2 %></span>
          </div>

        <% 4 -> %>
          <div>
            <span class="text-xs font-semibold inline-block py-1 px-2 rounded text-blue-500 bg-blue-50"><%= @entry.character.name %></span> würfelt 3 <span class="text-xs font-semibold inline-block p-1 rounded border border-gray-300 bg-gray-50 text-gray-500">W6</span>
          </div>
          <div>
            <span class="text-xs font-bold inline-block py-1 rounded text-center text-gray-500 border border-gray-300 bg-gray-100 w-6"><%= @entry.x1 %></span>
            <span class="text-xs font-bold inline-block py-1 rounded text-center text-gray-500 border border-gray-300 bg-gray-100 w-6"><%= @entry.x2 %></span>
            <span class="text-xs font-bold inline-block py-1 rounded text-center text-gray-500 border border-gray-300 bg-gray-100 w-6"><%= @entry.x3 %></span> »
            <span class="font-extrabold text-gray-900 mr-1"><%= @entry.x1 + @entry.x2 + @entry.x3 %></span>
          </div>

        <% 5 -> %>
          <div>
            <span class="text-xs font-semibold inline-block py-1 px-2 rounded text-blue-500 bg-blue-50"><%= @entry.character.name %></span> würfelt 3 <span class="text-xs font-semibold inline-block p-1 rounded border border-gray-300 bg-gray-50 text-gray-500">W20</span>
          </div>
          <div>
            <span class="text-xs font-bold inline-block py-1 rounded text-center text-gray-500 border border-gray-300 bg-gray-100 w-6"><%= @entry.x1 %></span>
            <span class="text-xs font-bold inline-block py-1 rounded text-center text-gray-500 border border-gray-300 bg-gray-100 w-6"><%= @entry.x2 %></span>
            <span class="text-xs font-bold inline-block py-1 rounded text-center text-gray-500 border border-gray-300 bg-gray-100 w-6"><%= @entry.x3 %></span>
          </div>

        <% 6 -> %>
          <%= trait_roll(assigns) %>

        <% _ -> %>
          Unbekannter Logeintrag
      <% end %>
    </div>
    """
  end

  defp quickroll_1w20(assigns) do
    ~L"""
    <div class='mr-1'>
      <%= label(:blue, @entry.character.name) %> würfelt <%= label(:yellow, "W20") %>
    </div>
    <div class='mx-1 <%= unless @dice, do: "hidden" %>'><%= label(:gray, @entry.x1) %></div>
    <div class='ml-1 <%= unless @result, do: "hidden" %>'><%= label(:bold, @entry.x1) %></div>
    """
  end

  defp trait_roll(assigns) do
    ~L"""
    <div class='mr-1'>
      <%= label(:blue, @entry.character.name) %> Eigenschaftsprobe <%= label(:yellow, trait(@entry.x1)) %><%= modifier(@entry.x3) %>
    </div>
    <div class='mx-1 <%= unless @dice, do: "hidden" %>'>
      <%= label(:gray, @entry.x4) %>
      <%= if @entry.x4 == 1 || @entry.x4 == 20, do: label(:gray, @entry.x5) %>
    </div>
    <div class='ml-1 <%= unless @result, do: "hidden" %>'>
      <%= cond do %>
        <%= @entry.x4 == 1 && @entry.x5 <= @entry.x2 + @entry.x3 -> %>
          <%= label(:green, "✓ K!") %>

        <%= @entry.x4 == 1 -> %>
          <%= label(:green, "✓") %>

        <%= @entry.x4 == 20 && @entry.x5 > @entry.x2 + @entry.x3 -> %>
          <%= label(:red, "✗ K!") %>

        <%= @entry.x4 == 20 -> %>
          <%= label(:red, "✗") %>

        <%= @entry.x5 <= @entry.x2 + @entry.x3 -> %>
          <%= label(:green, "✓") %>

        <%= true -> %>
          <%= label(:red, "✗") %>
      <% end %>
    </div>
    """
  end

  defp modifier(value) do
    cond do
      value < 0 -> label(:red, value)
      value > 0 -> label(:green, value)
      true -> nil
    end
  end

  defp trait(index), do: Enum.at(~w(MU KL IN CH GE FF KO KK), index)

  defp separator, do: content_tag(:span, "»", class: "inline-block align-middle")

  defp label(type, content) do
    class =
      case type do
        :blue ->
          "inline-block text-xs font-semibold p-1 rounded text-blue-500 bg-blue-50"

        :gray ->
          "text-xs font-semibold inline-block rounded text-center text-gray-500 border border-gray-300 bg-gray-100 w-5 h-5"

        :yellow ->
          "inline-block text-xs font-semibold p-1 rounded bg-yellow-50 text-yellow-600"

        :red ->
          "inline-block text-xs font-semibold p-1 rounded bg-red-50 text-red-500"

        :green ->
          "inline-block text-xs font-semibold p-1 rounded bg-green-50 text-green-500"

        :bold ->
          "inline-block font-extrabold text-gray-900 align-middle"
      end
    content_tag(:span, content, class: class)
  end
end
