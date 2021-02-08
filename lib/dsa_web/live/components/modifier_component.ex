defmodule DsaWeb.ModifierComponent do

  use DsaWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class='grid grid-cols-4 md:grid-cols-8 pb-3 gap-4 font-bold text-sm leading-6'>

      <h3>Modifier</h3>

      <div class="col-span-3 grid grid-cols-6 text-sm font-medium">
        <%= modifier_field -6, @modifier %>
        <%= modifier_field -5, @modifier %>
        <%= modifier_field -4, @modifier %>
        <%= modifier_field -3, @modifier %>
        <%= modifier_field -2, @modifier %>
        <%= modifier_field -1, @modifier %>
      </div>

      <%= modifier_field 0, @modifier %>

      <div class="col-span-3 grid grid-cols-6 text-sm font-medium">
        <%= modifier_field 1, @modifier %>
        <%= modifier_field 2, @modifier %>
        <%= modifier_field 3, @modifier %>
        <%= modifier_field 4, @modifier %>
        <%= modifier_field 5, @modifier %>
        <%= modifier_field 6, @modifier %>
      </div>
    </div>
    """
  end

  defp modifier_field(value, modifier) do
    active = modifier == value

    rounded_class =
      case value do
        -6 -> " rounded-l-md"
        -1 -> " rounded-r-md"
        6  -> " rounded-r-md"
        1  -> " rounded-l-md"
        _ -> nil
      end

    extra_classes =
      cond do
        value < 0 && active ->     "text-red-800 bg-red-200 border-red-400"
        value < 0 && not active -> "text-red-800 bg-red-50 border-gray-300"
        value > 0 && active ->     "text-green-800 bg-green-200 border-green-400"
        value > 0 && not active -> "text-green-800 bg-green-50 border-gray-300"
        true ->                    "text-gray-700 bg-gray-50 border-gray-300"
      end

    assigns = %{ rounded_class: rounded_class, extra_classes: extra_classes, value: value }

    ~L"""
      <button class='w-full leading-6 h-6 text-center border <%= @rounded_class %> <%= @extra_classes %>' phx-click='set-modifier' phx-value-modifier='<%= @value %>'><%= @value %></button>
    """
  end
end
