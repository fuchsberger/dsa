defmodule DsaWeb.GroupView do
  use DsaWeb, :view

  import Dsa.Game.Character, only: [talents: 1]

  alias Dsa.Event.TraitRoll

  def active_character_id(assigns), do: assigns.changeset_active_character.changes.id

  def character(assigns), do: Enum.find(assigns.group.characters, & &1.id == active_character_id(assigns))

  def modifier_options(range), do: Enum.map(range, & {&1, &1})

  def owner?(group, character_id), do: Enum.any?(group.characters, & &1.id == character_id)

  def character_options(group, user_id) do
    master? = group.master_id == user_id

    Enum.map(group.characters, & [
      key: "#{&1.name} - #{&1.profession}",
      value: &1.id,
      disabled: &1.user_id != user_id || not master?
    ])
  end

  def skill_options(characters, id) do
    characters
    |> Enum.find(& &1.id == id)
    |> Map.get(:character_skills)
    |> Enum.map(& &1.skill)
    |> options()
  end

  def calculate_result(%TraitRoll{} = r) do
    res1 = r.level - r.be + r.modifier - r.w1
    res2 = r.level - r.be + r.modifier - r.w1b

    case r.w1 do
      1 -> if res2 >= 0, do: {res1, true, "success"}, else: {res1, nil, "success"}
      20 -> if res2 < 0, do: {res1, false, "danger"}, else: {res1, nil, "danger"}
      _ -> {res1, nil, (if res1 < 0, do: "danger", else: "success")}
    end
  end

  def result_text(res, critical) do
    cond do
      critical == true -> "meisterlich bewältigt!"
      critical == false -> "unglücklich verpatzt!"
      res < 0 -> "nicht bestanden."
      res >= 0 -> "bestanden."
    end
  end
end
