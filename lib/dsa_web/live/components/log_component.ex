defmodule LogComponent do

  use Phoenix.LiveComponent

  import Phoenix.HTML.Tag, only: [content_tag: 3]
  import Phoenix.View, only: [render: 3]

  alias DsaWeb.LogView

  def render(assigns) do
    ~L"""
    <div id='log-<%= @entry.id %>' class='rounded-md bg-white shadow-md my-2 py-1 px-2 flex justify-between'>
      <%= case @entry.type do %>

        <% 2 -> %><%= quickroll_w6(assigns) %>
        <% 3 -> %><%= quickroll_2w6(assigns) %>
        <% 4 -> %><%= quickroll_3w6(assigns) %>
        <% 5 -> %><%= quickroll_3w20(assigns) %>
        <% 6 -> %><%= trait_roll(assigns) %>
        <% 7 -> %><%= talent_roll(assigns) %>
        <% _ -> %> Unbekannter Logeintrag
      <% end %>
    </div>
    """
  end

  defp quickroll_w6(assigns) do
    ~L"""
    <div class='mr-1'>
      <%= label(:blue, @entry.character.name) %> würfelt <%= label(:yellow, "W6") %>
    </div>
    <div class='mx-1 <%= unless @dice, do: "hidden" %>'><%= label(:gray, @entry.x1) %></div>
    <div class='ml-1 <%= unless @result, do: "hidden" %>'><%= label(:bold, @entry.x1) %></div>
    """
  end

  defp quickroll_2w6(assigns) do
    ~L"""
    <div class='mr-1'>
      <%= label(:blue, @entry.character.name) %> würfelt <%= label(:yellow, "2 W6") %>
    </div>
    <div class='mx-1 <%= unless @dice, do: "hidden" %>'><%= label(:gray, @entry.x1) %> <%= label(:gray, @entry.x2) %></div>
    <div class='ml-1 <%= unless @result, do: "hidden" %>'><%= label(:bold, @entry.x1 + @entry.x2) %></div>
    """
  end

  defp quickroll_3w6(assigns) do
    ~L"""
    <div class='mr-1'>
      <%= label(:blue, @entry.character.name) %> würfelt <%= label(:yellow, "3 W6") %>
    </div>
    <div class='mx-1 <%= unless @dice, do: "hidden" %>'><%= label(:gray, @entry.x1) %> <%= label(:gray, @entry.x2) %> <%= label(:gray, @entry.x3) %></div>
    <div class='ml-1 <%= unless @result, do: "hidden" %>'><%= label(:bold, @entry.x1 + @entry.x2 + @entry.x3) %></div>
    """
  end

  defp quickroll_3w20(assigns) do
    ~L"""
    <div class='mr-1'>
      <%= label(:blue, @entry.character.name) %> würfelt <%= label(:yellow, "3 W20") %>
    </div>
    <div class='mx-1 <%= unless @dice, do: "hidden" %>'><%= label(:gray, @entry.x1) %> <%= label(:gray, @entry.x2) %> <%= label(:gray, @entry.x3) %></div>
    <div class='ml-1 <%= unless @result, do: "hidden" %>'><%= label(:bold, @entry.x1 + @entry.x2 + @entry.x3) %></div>
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

  defp talent_roll(assigns) do

    ~L"""
    <div class='mr-1'>
      <%= label(:blue, @entry.character.name) %> Talentprobe <%= label(:yellow, "#{trait(@entry.x1)}/#{trait(@entry.x2)}/#{trait(@entry.x3)}") %><%= modifier(@entry.x10) %>
    </div>
    <div class='mx-1 <%= unless @dice, do: "hidden" %>'>
      <%= label(:gray, @entry.x7) %>
      <%= label(:gray, @entry.x8) %>
      <%= label(:gray, @entry.x9) %>
    </div>
    <div class='ml-1 <%= unless @result, do: "hidden" %>'>
      <%= cond do %>
        <%= Enum.count([@entry.x4, @entry.x5, @entry.x6], & &1 == 1) >= 2 -> %>
          <%= label(:green, "✓ K!") %>

          <%= Enum.count([@entry.x4, @entry.x5, @entry.x6], & &1 == 20) >= 2 -> %>
          <%= label(:green, "✗ K!") %>

        <%= true -> %>
          <%= label(:bold, "TW: #{@entry.x11}") %>

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

  defp separator, do: content_tag(:span, "»", class: "inline-block align-middle mx-1 lg:mx-2")

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
