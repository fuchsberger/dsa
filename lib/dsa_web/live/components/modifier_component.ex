defmodule DsaWeb.ModifierComponent do

  use DsaWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class='grid grid-cols-4 md:grid-cols-8 pb-3 gap-4 font-bold text-sm leading-6'>

      <h3 class='leading-6 border-2 border-transparent'>Modifier</h3>

      <div class="col-span-3 grid grid-cols-6 text-sm text-center font-medium">
        <%= for value <- -6..-1 do %>
          <%= modifier_button(@modifier, value) %>
        <% end %>
      </div>
      <%= modifier_button(@modifier, 0)  %>
      <div class="col-span-3 grid grid-cols-6 text-sm font-medium">
        <%= for value <- 1..6 do %>
          <%= modifier_button(@modifier, value) %>
        <% end %>
      </div>
    </div>
    """
  end

  defp modifier_button(modifier, value) do
    base =
      cond do
        value > 0 -> "positive"
        value < 0 -> "negative"
        true -> "neutral"
      end

    assigns = %{
      class: (if modifier == value, do: "#{base} active", else: base),
      value: value
    }

    ~L"""
    <button class='<%= @class %>' phx-click='assign' phx-value-modifier='<%= @value %>'><%= @value %></button>
    """
  end
end
