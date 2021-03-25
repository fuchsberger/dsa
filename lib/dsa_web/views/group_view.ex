defmodule DsaWeb.GroupView do
  use DsaWeb, :view

  def combat_set_options(character) do
    Enum.map(character.combat_sets, & {&1.name, &1.id})
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
end
