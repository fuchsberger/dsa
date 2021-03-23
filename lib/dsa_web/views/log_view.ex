defmodule DsaWeb.LogView do
  use DsaWeb, :view

  import Dsa.Trial, only: [roll: 3]

  alias Dsa.Event.{Log, TraitRoll, MainLog}

  @base "inline-block font-semibold leading-6 px-1 rounded"

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

  defp result(%TraitRoll{} = roll) do
    case {roll.success, roll.critical} do
      {false, true} -> content_tag :span, "✗ K!", class: "#{@base} bg-red-50 text-red-500"
      {true, true} -> content_tag :span, "✓ K!", class: "#{@base} bg-green-50 text-green-500"
      {false, false} -> content_tag :span, "✗", class: "#{@base} bg-red-50 text-red-500"
      {true, false} -> content_tag :span, "✓", class: "#{@base} bg-green-50 text-green-500"
    end
  end

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
    end
  end

  def result_tag(result_type) do
    case result_type do
      MainLog.ResultType.Failure -> "#{@base} bg-red-50 text-red-500"
      _ -> "#{@base} bg-green-50 text-green-500"
    end
  end

  defp result_tag_trial(quality, critical?) do
    case {quality, critical?} do
      {0, true} -> content_tag :span, "✗ K!", class: "#{@base} bg-red-50 text-red-500"
      {_, true} -> content_tag :span, "✓ K!", class: "#{@base} bg-green-50 text-green-500"
      {0, false} -> content_tag :span, "✗", class: "#{@base} bg-red-50 text-red-500"
      {q, false} -> content_tag :span, "✓ #{q}", class: "#{@base} bg-green-50 text-green-500"
    end
  end

end
