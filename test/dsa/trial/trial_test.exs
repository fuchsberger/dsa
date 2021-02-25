# Unit Test
defmodule Dsa.TrialTest do
  use ExUnit.Case

  test "sanity check for non randomized version" do
    Dsa.Trial.roll(10)
    {a, _} = Dsa.Trial.roll_dice({10, :a})
    assert a == 10
    [{a, _}, {b, _}] = Dsa.Trial.roll_dices([{10, :a}, {11, :b}])
    assert [a, b] == [10, 11]
    [{a, _}, {a, _}, {a, _}] = Dsa.Trial.roll_dices(10, 3)
    assert a == 10
  end

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

  test "when passing a dice that was not rolled roll the dice" do
    input = 6
    random_return = 5

    randomizer = fn i ->
      assert i == input
      random_return
    end

    {pips, result} = Dsa.Trial.roll_dice({input, :not_rolled}, randomizer)
    assert pips == input
    assert result == random_return
  end

  test "when passing a dice that was already rolled do not roll again " do
    input = 6
    previous_roll = 4
    random_return = 5

    randomizer = fn i ->
      assert i == input
      random_return
    end

    {pips, result} = Dsa.Trial.roll_dice({input, previous_roll}, randomizer)
    assert pips == input
    assert result == previous_roll
  end

  test "when passing multiple dices we return the roll for each dice except for already rolled ones" do
    dice1 = {6, :not_rolled}
    dice2 = {16, :not_rolled}
    dice3 = {63, 5}
    input = [dice1, dice2, dice3]

    random_return = 5
    expected_result = [{6, random_return}, {16, random_return}, {63, 5}]

    randomizer = fn _ ->
      random_return
    end

    result = Dsa.Trial.roll_dices(input, randomizer)
    assert result == expected_result
  end

  test "when passing the pibs and the number of dices we roll for each dice" do
    pib_input = 20
    random_return = 5
    number_dices = 3

    expected_result = [
      {pib_input, random_return},
      {pib_input, random_return},
      {pib_input, random_return}
    ]

    randomizer = fn _ ->
      random_return
    end

    result = Dsa.Trial.roll_dices(pib_input, number_dices, randomizer)
    assert result == expected_result
  end

  test "when a trial is passing it returns success and the remainder" do
    dice1 = {20, 9}
    skill = 9
    modifier = 0

    {status, dif} = Dsa.Trial.perform_trial(dice1, skill, modifier)
    assert status == :pass
    assert dif == 0
  end

  test "when a trial is passing because of the modifier it returns success and the remainder" do
    dice1 = {20, 10}
    skill = 7
    modifier = 3

    {status, dif} = Dsa.Trial.perform_trial(dice1, skill, modifier)
    assert status == :pass
    assert dif == 0
  end

  test "when a trial is not passing it returns success and the difference" do
    dice1 = {20, 10}
    skill = 9
    modifier = 0

    {status, dif} = Dsa.Trial.perform_trial(dice1, skill, modifier)
    assert status == :fail
    assert dif == -1
  end

  test "when a trial is not passing because of the modifier it returns success and the difference" do
    dice1 = {20, 10}
    skill = 9
    modifier = -3

    {status, dif} = Dsa.Trial.perform_trial(dice1, skill, modifier)
    assert status == :fail
    assert dif == -4
  end

  test "critical roll" do
    assert Dsa.Trial.is_critical_success?([1, 2, 1]) == true
    assert Dsa.Trial.is_critical_success?([4, 1, 1]) == true
    assert Dsa.Trial.is_critical_success?([1, 1, 5]) == true
    assert Dsa.Trial.is_critical_success?([1, 1, 1]) == true

    assert Dsa.Trial.is_critical_success?([1, 4, 3]) == false
    assert Dsa.Trial.is_critical_success?([3, 2, 1]) == false

    assert Dsa.Trial.is_critical_failure?([20, 8, 20]) == true
    assert Dsa.Trial.is_critical_failure?([20, 20, 20]) == true
    assert Dsa.Trial.is_critical_failure?([5, 20, 20]) == true
    assert Dsa.Trial.is_critical_failure?([20, 20, 4]) == true
    assert Dsa.Trial.is_critical_failure?([20, 2, 20]) == true

    assert Dsa.Trial.is_critical_failure?([1, 4, 3]) == false
    assert Dsa.Trial.is_critical_failure?([1, 4, 20]) == false
  end

  test "skill roll: failure" do
    Dsa.Trial.perform_talent_trial([10, 10, 10], 4, 0, [
      {20, :not_rolled},
      {20, :not_rolled},
      {20, :not_rolled}
    ])

    # too little, single
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, 0, [
             {20, 10},
             {20, 15},
             {20, 10}
           ]) == -1

    # too little, split
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, 0, [
             {20, 10},
             {20, 12},
             {20, 13}
           ]) == -1

    # with modifier
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, -1, [
             {20, 10},
             {20, 12},
             {20, 10}
           ]) == -1

    # with modifier, split
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, -1, [
             {20, 10},
             {20, 11},
             {20, 11}
           ]) == -1

    # modifier only
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, -2, [
             {20, 10},
             {20, 10},
             {20, 10}
           ]) == -1
  end

  test "skill roll: success" do
    # all dice below or equal
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, 1, [
             {20, 10},
             {20, 10},
             {20, 10}
           ]) == 2

    # negative modifier
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, -1, [
             {20, 10},
             {20, 10},
             {20, 10}
           ]) == 1

    # positive modifier
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, 6, [
             {20, 10},
             {20, 10},
             {20, 10}
           ]) == 2

    # 1 skill point used
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, 0, [
             {20, 10},
             {20, 11},
             {20, 10}
           ]) == 2

    # 2 skill points used
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, 0, [
             {20, 10},
             {20, 12},
             {20, 10}
           ]) == 1

    # 4 skill points used
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 4, 0, [
             {20, 10},
             {20, 14},
             {20, 10}
           ]) == 1

    # don't allow quality above 6
    assert Dsa.Trial.perform_talent_trial([10, 10, 10], 25, 0, [
             {20, 10},
             {20, 10},
             {20, 10}
           ]) == 6
  end
end
