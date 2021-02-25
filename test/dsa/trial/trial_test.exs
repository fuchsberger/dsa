# Unit Test
defmodule Dsa.TrialTest do
  use ExUnit.Case

  for {input, random_return} <- [{6, 5}, {16, 34}, {0, 1}, {:a, 7}] do
    test "when doing a roll for  #{input} we return the result of the randomizer #{random_return}" do
      input = 6
      random_return = 5

      randomizer = fn i ->
        assert i == input
        random_return
      end

      result = Dsa.Trial.roll(input, randomizer)

      assert result == random_return
    end
  end

  test "when passing a dice we return the roll for the dice" do
    input = 6
    random_return = 5

    randomizer = fn i ->
      assert i == input
      random_return
    end

    {pips, result} = Dsa.Trial.roll_dice({input, 0}, randomizer)
    assert pips == input
    assert result == random_return
  end

  test "when passing multiple dices we return the roll for each dice" do
    dice1 = {6, :a}
    dice2 = {16, :a}
    dice3 = {63, :a}
    input = [dice1, dice2, dice3]

    random_return = 5
    expected_result = [{6, random_return}, {16, random_return}, {63, random_return}]

    randomizer = fn i ->
      random_return
    end

    res = Dsa.Trial.roll_dices(input, randomizer)
    assert res == expected_result
  end
end
