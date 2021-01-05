defmodule DsaWeb.LogView do
  use DsaWeb, :view

  import Phoenix.HTML.Tag, except: [tag: 2]

  @base "inline-block text-xs font-semibold p-1 rounded"

  defp tag(:blue, c), do: content_tag :span, c,
    class: "#{@base} text-blue-500 bg-blue-50 border border-blue-200"

  defp tag(:green, c), do: content_tag :span, c, class: "#{@base} bg-green-50 text-green-500"

  defp tag(:red, c), do: content_tag :span, c, class: "#{@base} bg-red-50 text-red-500"

  defp tag(:yellow, c), do: content_tag :span, c,
    class: "#{@base} bg-yellow-50 text-yellow-600 border border-yellow-200"

  defp tag(:dice, c), do: content_tag :span, c,
    class: "#{@base} text-gray-500 border border-md border-gray-300 bg-gray-100 w-6 text-center"

  defp tag(:text, c), do: content_tag :span, c, class: "inline-block font-semibold font-bold text-gray-900"

  defp separator, do: content_tag(:span, "»", class: "mx-1 lg:mx-2")
end
