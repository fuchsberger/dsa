defmodule DsaWeb.GroupView do
  use DsaWeb, :view

  alias Dsa.Characters

  def combat_set_options(character) do
    Enum.map(character.combat_sets, & {&1.name, &1.id})
  end

  def at_button(%{id: id, active_combat_set: %{at: at}}) do
    content_tag :button, "AT #{at}",
      type: "button",
      phx_click: "roll-at",
      phx_value_id: id,
      class: "label dice w-full h-7 text-xs px-0 truncate"
  end

  def pa_button(%{id: id, active_combat_set: %{pa: pa}}) do
    content_tag :button, "PA #{pa}",
      type: "button",
      phx_click: "roll-pa",
      phx_value_id: id,
      class: "label dice w-full h-7 text-xs px-0 truncate"
  end

  def ini_button(socket, %{id: id, ini: ini}) do
    class = if is_nil(ini), do: "label link", else: "label dice"
    text = if is_nil(ini), do: icon(socket, "login"), else: ini

    content_tag :button, text,
      type: "button",
      phx_click: "roll-ini",
      phx_value_id: id,
      class: class
  end

  def dmg_button(%{id: id, active_combat_set: set}) do
    content_tag :button, "W+#{set.tp_bonus}",
      type: "button",
      phx_click: "roll-dmg",
      phx_value_id: id,
      class: "label dice w-full h-7 text-xs px-0 truncate"
  end

  def dmg(%{tp_dice: count, tp_type: type, tp_bonus: bonus}) do
    "#{count}W#{type}#{if bonus >= 0, do: "+"}#{bonus}"
  end
end
