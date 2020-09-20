defmodule DsaWeb.GroupView do
  use DsaWeb, :view

  import Dsa.Lists
  import DsaWeb.CharacterHelpers

  alias Dsa.Event.{TraitRoll, TalentRoll}

  def badge(:name, name), do: content_tag :span, name, class: "badge bg-secondary"

  def badge(:quality, _res, true), do: content_tag :span, "X", class: "badge bg-success"

  def badge(:quality, res, critical) when res >= 0 and critical != false do
    content_tag :span, quality(res), class: "badge bg-success"
  end

  def badge(:quality, _res, _critical), do: ""

  def modifier_badge(0), do: ""

  def modifier_badge(modifier) do
    {color, symbol} =
      cond do
        modifier < 0 -> {"danger", ""}
        modifier > 0 -> {"success", "+"}
      end

    content_tag(:span, "#{symbol}#{modifier}", class: "rounded-0 rounded-right badge bg-#{color}")
  end

  def character(assigns) do
    Enum.find(assigns.group.characters, & &1.id == get_field(assigns.settings, :character_id))
  end

  def modifier_options(range), do: Enum.map(range, & {&1, &1})

  def owner?(group, user_id, character_id) do
    group.characters
    |> Enum.filter(& &1.user_id == user_id)
    |> Enum.map(& &1.id)
    |> Enum.member?(character_id)
  end

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

  def base_roll_result(log) do
    res1 = log.x2 + log.x3 - log.x4
    res2 = log.x2 + log.x3 - log.x5

    case log.x4 do
      1 -> if res2 >= 0, do: {res1, true, "success"}, else: {res1, nil, "success"}
      20 -> if res2 < 0, do: {res1, false, "danger"}, else: {res1, nil, "danger"}
      _ -> {res1, nil, (if res1 < 0, do: "danger", else: "success")}
    end
  end

  def talent_roll_result(log) do
    m = log.x4 - log.x9
    res = log.x5 - max(0, log.x1 - log.x6 - m) - max(0, log.x2 - log.x7 - m) - max(0, log.x3 - log.x8 - m)

    cond do
      Enum.count([log.x1, log.x2, log.x3], & &1 == 1) > 1 -> {res, true, "success"}
      Enum.count([log.x1, log.x2, log.x3], & &1 == 20) > 1 -> {res, false, "danger"}
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

  def routine_possible?(character, skill_id, modifier) do
    probe = skill(skill_id, :probe)
    [t1, t2, t3] = probe_values(probe, character)
    fw = Map.get(character, String.to_atom("t#{skill_id}"))

    cond do
      Enum.min([t1, t2, t3]) < 13 -> {false, nil}
      modifier >= 3 && fw >= 1 -> {true, quality(fw/2)}
      modifier >= 2 && fw >= 4 -> {true, quality(fw/2)}
      modifier >= 1 && fw >= 7 -> {true, quality(fw/2)}
      modifier >= 0 && fw >= 10 -> {true, quality(fw/2)}
      modifier >= -1 && fw >= 13 -> {true, quality(fw/2)}
      modifier >= -2 && fw >= 16 -> {true, quality(fw/2)}
      modifier >= -3 && fw >= 19 -> {true, quality(fw/2)}
      true ->
        cond do
          fw >= 19 -> {false, -3}
          fw >= 16 -> {false, -2}
          fw >= 13 -> {false, -1}
          fw >= 10 -> {false, 0}
          fw >= 7 -> {false, 1}
          fw >= 4 -> {false, 2}
          fw >= 1 -> {false, 3}
          true -> {false, nil}
        end
    end
  end

  def talent_group(character, category) do
    Enum.filter(character.character_skills, & &1.skill.category == category)
  end

  defp roll_count(log) do
    index =
      2..10
      |> Enum.map(& String.to_atom("x#{&1}"))
      |> Enum.find_index(& is_nil(Map.get(log, &1)))

    index + 1
  end

  def base_value(index) do
    base_values()
    |> Enum.at(index)
    |> Atom.to_string()
    |> String.upcase()
  end

  def base_value(character, index) do
    Map.get(character, Enum.at(base_values(), index))
  end

  def base_value_indexes(probe) do
    [b1, b2, b3] =
      probe
      |> String.downcase()
      |> String.split("/")
      |> Enum.map(& String.to_atom(&1))

    [
      Enum.find_index(base_values(), & &1 == b1),
      Enum.find_index(base_values(), & &1 == b2),
      Enum.find_index(base_values(), & &1 == b3)
    ]
  end
end
