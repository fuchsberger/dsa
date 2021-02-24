defmodule Dsa.Trial do
  @moduledoc """
  This module handles all logic regarding trialing
  """


  def roll(maxnumber), do: roll(maxnumber, &(Enum.random(&1)))
  def roll(maxnumber, rand) do
    rand.(maxnumber)
  end

  def roll_dice(dice), do: roll(dice, &(Enum.random(&1)))
  def roll_dice({pips, _ } = dice, rand) when pips > -1 do
    {pips, roll(pips, rand)}
  end

  def roll_dices(dices), do: roll(dices, &(Enum.random(&1)))
  def roll_dices(dices, rand) when is_list(dices) do
    Enum.map(dices, fn dice -> roll_dice(dice, rand) end)
  end
end
