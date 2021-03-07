defmodule Dsa.Trial do
  @moduledoc """
  This module handles all logic regarding trialing
  """

  alias Dsa.Accounts.Character

  def roll(maxnumber), do: roll(maxnumber, &:rand.uniform(&1))

  def roll(maxnumber, rand) do
    rand.(maxnumber)
  end

  def roll_dice(dice), do: roll_dice(dice, &:rand.uniform(&1))

  def roll_dice({pips, result}, rand) when pips > -1 do
    case result do
      :not_rolled -> {pips, roll(pips, rand)}
      _ -> {pips, result}
    end
  end

  def roll_dices(dices), do: roll_dices(dices, &:rand.uniform(&1))

  def roll_dices(dices, rand) when is_list(dices) do
    Enum.map(dices, fn dice -> roll_dice(dice, rand) end)
  end

  def roll_dices(pibs, count), do: roll_dices(pibs, count, &:rand.uniform(&1))

  def roll_dices(pibs, count, rand) do
    Enum.map(0..(count - 1), fn _ -> {pibs, :not_rolled} end)
    |> Enum.map(fn dice -> roll_dice(dice, rand) end)
  end

  def perform_trial({_pib, dice_roll} = dice, skill_point, modifier) do
    skill_point_modified = skill_point + modifier

    case dice_roll do
      dice_roll when dice_roll <= skill_point_modified ->
        {:pass, skill_point_modified - dice_roll}

      :not_rolled ->
        perform_trial(roll_dice(dice), skill_point, modifier)

      _ ->
        {:fail, skill_point_modified - dice_roll}
    end
  end

  def is_critical_success?(numbers), do: Enum.count(numbers, &(&1 == 1)) >= 2
  def is_critical_failure?(numbers), do: Enum.count(numbers, &(&1 == 20)) >= 2

  def criticality(numbers) do
    is_critical_success?(numbers) || is_critical_failure?(numbers)
  end

  def criticality(numbers, result) do
    criticality = {is_critical_success?(numbers), is_critical_failure?(numbers)}

    case criticality do
      {true, _} -> :critical_success
      {false, true} -> :critical_failure
      _ when result >= 0 -> :pass
      _ -> :fail
    end
  end

  def talent_quality(remaining), do: min(6, div(remaining, 3) + 1)

  def perform_talent_trial(traits, skill_point, modifier, dices) do
    diff =
      Enum.zip(traits, dices)
      |> Enum.map(fn {trait, dice} -> perform_trial(dice, trait, modifier) |> elem(1) end)
      |> Enum.map(fn n -> min(n, 0) end)
      |> Enum.sum()

    case diff do
      _ when skill_point + diff < 0 ->
        0
      _ ->
        talent_quality(skill_point + diff)
    end
  end

  def perform_trait_trial(trait, modifier, [{_, d1}, {_, d2}]) do
    cond do
      d1 == 1 && d2 <= (trait + modifier) -> {true, true}
      d1 == 20 && d2 > (trait + modifier) -> {false, true}
      d1 <= (trait + modifier) -> {true, false}
      true -> {false, false}
    end
  end

  @doc """
  Performs a trial on a character (skills or magic)
  Returns a tuple {quality, cricitcally?}
  """
  def handle_skill_event(%Character{} = character, skill_id, modifier) do
    character_skill = Enum.find(character.character_skills, & &1.skill_id == skill_id)
    traits = get_character_trait_values(character, character_skill.skill.probe)
    dices = Dsa.Trial.roll_dices(20, 3)
    [{_, d1}, {_, d2}, {_, d3}] = dices

    quality = Dsa.Trial.perform_talent_trial(traits, character_skill.level, modifier, dices)
    critically? = criticality([d1, d2, d3])

    {{d1, d2, d2}, quality, critically?}
  end
  require Logger
  def handle_trait_event(%Character{} = character, trait, modifier) do
    dices = Dsa.Trial.roll_dices(20, 2)
    [{_, d1}, {_, d2}] = dices

    Logger.warn inspect {d1, d2}
    {success?, critical?} =
      Dsa.Trial.perform_trait_trial(Map.get(character, trait), modifier, dices)

    {{d1, d2, 0}, success?, critical?}
  end

  def handle_trial_event(traits, level, modifier, group_id, character_id, type, skill_id) do
    dices = Dsa.Trial.roll_dices(20, 3)
    [{_, d1}, {_, d2}, {_, d3}] = dices
    result = Dsa.Trial.perform_talent_trial(traits, level, modifier, dices)

    %{
      data: %{
        "skill_id" => skill_id,
        "dice1" => d1,
        "dice2" => d2,
        "dice3" => d3,
        "modifier" => modifier,
        "result" => result,
        "criticality" => criticality([d1, d2, d3], result)
      },
      character_id: character_id,
      group_id: group_id,
      type: type
    }
  end

  @doc """
  Given a character and a probe (Example: {:mu, :kl, :ch}), returns the characters traits for it
  """
  defp get_character_trait_values(%Character{} = character, {t1, t2, t3}) do
    [Map.get(character, t1), Map.get(character, t2), Map.get(character, t3)]
  end
end
