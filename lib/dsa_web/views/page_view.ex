defmodule DsaWeb.PageView do
  use DsaWeb, :view

  def modifier_field(form, value) do
    active = input_value(form, :modifier) == value

    rounded_class =
      case value do
        -6 -> " rounded-l-md"
        6 -> " rounded-r-md"
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

    label class: "w-9 py-1 text-center border #{rounded_class} #{extra_classes}" do
      [
        radio_button(form, :modifier, value, checked: active, class: "hidden"),
        "#{value}"
      ]
    end
  end

  defp trait_roll_button(trait, user) do

    trait_name =
      trait
      |> Atom.to_string()
      |> String.upcase()

    case user && user.active_character do
      true ->
        content_tag :button, "#{trait_name}: #{Map.get(user.active_character, trait)}",
          type: "button",
          class: "bg-white py-2 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500",
          phx_click: "roll",
          phx_value_trait: trait

      nil ->
        nil
    end
  end
end
