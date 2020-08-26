defmodule DsaWeb.GroupView do
  use DsaWeb, :view

  import Ecto.Changeset, only: [get_field: 2]

  alias Dsa.Event.{GeneralRoll, TraitRoll, TalentRoll}

  def badge(:name, name), do: content_tag :span, name, class: "badge bg-secondary"

  def badge(:quality, _res, true), do: content_tag :span, "X", class: "badge bg-success"

  def badge(:quality, res, critical) when res >= 0 and critical != false do
    content_tag :span, quality(res), class: "badge bg-success"
  end

  def badge(:quality, _res, _critical), do: ""

  def badge(:roll, name, modifier) do
    [
      content_tag(:span, name, class: "badge bg-secondary rounded-0 rounded-left"),
      content_tag(:span, modifier, class: "badge bg-info rounded-0 rounded-right"),
    ]
  end

  def modifier_badge(modifier) do
    {color, symbol} =
      cond do
        modifier == 0 -> {"secondary", "+"}
        modifier < 0 -> {"danger", ""}
        modifier > 0 -> {"success", "+"}
      end

    content_tag(:span, "#{symbol}#{modifier}", class: "badge bg-#{color}")
  end

  def character(assigns) do
    Enum.find(assigns.group.characters, & &1.id == get_field(assigns.settings, :character_id))
  end

  def events(group) do
    group.trait_rolls ++ group.talent_rolls ++ group.general_rolls
    |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
    |> Enum.map(fn event ->
      case event do
        %GeneralRoll{} -> {:general_roll, event}
        %TraitRoll{} -> {:trait_roll, event}
        %TalentRoll{} -> {:talent_roll, event}
      end
    end)
  end

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

  def calculate_result(%TalentRoll{} = r) do
    m = r.modifier - r.be
    res = r.level - max(0, r.w1 - r.t1 - m) - max(0, r.w2 - r.t2 - m) - max(0, r.w3 - r.t3 - m)

    cond do
      Enum.count([r.w1, r.w2, r.w3], & &1 == 1) > 1 -> {res, true, "success"}
      Enum.count([r.w1, r.w2, r.w3], & &1 == 20) > 1 -> {res, false, "danger"}
      true -> {res, nil, (if res < 0, do: "danger", else: "success")}
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

  def talent_group(character, category) do
    Enum.filter(character.character_skills, & &1.skill.category == category)
  end
end
