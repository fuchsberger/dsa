defmodule Dsa.Trial do
  @moduledoc """
  This module handles all logic regarding trialing
  """

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

  def perform_trial({pib, dice_roll} = dice, skill_point, modifier) do
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
  def talent_quality(remaining), do: min(6, div(remaining, 3) + 1)

  def perform_talent_trial(traits, skill_point, modifier, dices) do
    diff =
      Enum.zip(traits, dices)
      |> Enum.map(fn {trait, dice} -> perform_trial(dice, trait, modifier) |> elem(1) end)
      |> Enum.map(fn n -> max(n, 0) end)
      |> Enum.sum()

    case diff do
      _ when skill_point + diff < 0 ->
        -1
      _ ->
        talent_quality(skill_point + diff)
    end
  end
end
