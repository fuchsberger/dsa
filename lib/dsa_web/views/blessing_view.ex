defmodule DsaWeb.BlessingView do
  use DsaWeb, :view

  @spread [
    %{id: 1, name: gettext("General")},
    %{id: 2, name: gettext("Guildmages")},
    %{id: 3, name: gettext("Elves")},
    %{id: 4, name: gettext("Witches")}
  ]

  # defp spread_options, do: Enum.map(@spread, & {&1.name, &1.id})

  defp spread(spread) do
    spread
    |> Enum.map(fn id -> Enum.find(@spread, & &1.id == id).name end)
    |> Enum.join(", ")
  end
end
