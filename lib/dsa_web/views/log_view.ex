defmodule DsaWeb.LogView do
  use DsaWeb, :view
  
  alias Dsa.Data.Spell
  alias Dsa.Data.Skill

  @base "inline-block font-semibold leading-6 px-1 rounded"

  defp spell_name(entry), do: Spell.name(entry)
  defp skill_name(entry), do: Skill.name(entry)

  defp separator, do: content_tag(:span, "»", class: "inline-block align-middle mx-1 lg:mx-2")

  defp trait(index), do: Enum.at(~w(MU KL IN CH GE FF KO KK), index)

  defp tag_helper(:blue, c), do: content_tag :span, c,
    class: "#{@base} text-blue-500 bg-blue-50 border border-blue-200"

  defp tag_helper(:green, c), do: content_tag :span, c, class: "#{@base} bg-green-50 text-green-500"

  defp tag_helper(:red, c), do: content_tag :span, c, class: "#{@base} bg-red-50 text-red-500"

  defp tag_helper(:yellow, c), do: content_tag :span, c,
    class: "#{@base} bg-yellow-50 text-yellow-600 border border-yellow-200"

  defp tag_helper(:dice, c), do: content_tag :span, c,
    class: "#{@base} text-gray-500 border border-md border-gray-300 bg-gray-100 w-6 ml-1 text-center"

  defp tag_helper(:text, c), do: content_tag :span, c, class: "leading-6 font-bold text-gray-900"

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

  defp trial_result(form,entry) do
  end
end
