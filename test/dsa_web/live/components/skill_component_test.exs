defmodule Dsa.SkillComponentTest do
  use ExUnit.Case

  alias DsaWeb.SkillComponent

  setup_all do
    {:ok, character: %Dsa.Accounts.Character{
      mu: 10, kl: 10, in: 10, ff: 10, ge: 10, ko: 10, kk: 10, t1: 4
    }}
  end

  test "skill roll: critical failure", %{character: character} do
    assert SkillComponent.result(character, 1, 0, 20, 20, 20) == -2
    assert SkillComponent.result(character, 1, 0, 20, 20, 0) == -2
    assert SkillComponent.result(character, 1, 0, 20, 0, 20) == -2
    assert SkillComponent.result(character, 1, 0, 0, 20, 20) == -2
  end

  test "skill roll: critical success", %{character: character} do
    assert SkillComponent.result(character, 1, 0, 1, 1, 1) == 10
    assert SkillComponent.result(character, 1, 0, 1, 20, 1) == 10
    assert SkillComponent.result(character, 1, 0, 1, 1, 20) == 10
    assert SkillComponent.result(character, 1, 0, 20, 1, 1) == 10
  end

  test "skill roll: failure", %{character: character} do
    assert SkillComponent.result(character, 1, 0, 10, 15, 10) == -1
    assert SkillComponent.result(character, 1, 0, 10, 12, 13) == -1
    # assert SkillComponent.result(character, 1, -1, 10, 12, 10) == -1
  end
end
