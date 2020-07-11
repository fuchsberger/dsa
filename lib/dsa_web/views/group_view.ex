defmodule DsaWeb.GroupView do
  use DsaWeb, :view

  def modifier_options(range), do: Enum.map(range, & {&1, &1})

  def owner?(group, character_id), do: Enum.any?(group.characters, & &1.id == character_id)

  def skill_options(characters, id) do
    characters
    |> Enum.find(& &1.id == id)
    |> Map.get(:character_skills)
    |> Enum.map(& &1.skill)
    |> Enum.reject(& &1.category == "Nahkampf" || &1.category == "Fernkampf")
    |> options()
  end
end
