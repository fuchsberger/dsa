defmodule Dsa.SkillComponentTest do
  use ExUnit.Case

  alias DsaWeb.SkillComponent

  test "skill roll: critical failure" do
    assert SkillComponent.result(10, 10, 10, 4, 0, 20, 20, 20) == -2 # tripple 20
    assert SkillComponent.result(10, 10, 10, 4, 0, 20, 20, 0) == -2 # double 20 variant 1
    assert SkillComponent.result(10, 10, 10, 4, 0, 20, 0, 20) == -2 # double 20 variant 2
    assert SkillComponent.result(10, 10, 10, 4, 0, 0, 20, 20) == -2 # double 20 variant 3
  end

  test "skill roll: critical success" do
    assert SkillComponent.result(10, 10, 10, 4, 0, 1, 1, 1) == 10 # triple 1
    assert SkillComponent.result(10, 10, 10, 4, 0, 1, 20, 1) == 10 # double 1 variant 1
    assert SkillComponent.result(10, 10, 10, 4, 0, 1, 1, 20) == 10 # double 1 variant 2
    assert SkillComponent.result(10, 10, 10, 4, 0, 20, 1, 1) == 10 # double 1 variant 3
  end

  test "skill roll: failure" do
    assert SkillComponent.result(10, 10, 10, 4, 0, 10, 15, 10) == -1 # too little, single
    assert SkillComponent.result(10, 10, 10, 4, 0, 10, 12, 13) == -1 # too little, split
    assert SkillComponent.result(10, 10, 10, 4, -1, 10, 12, 10) == -1 # with modifier
    assert SkillComponent.result(10, 10, 10, 4, -1, 10, 11, 11) == -1 # with modifier, split
    assert SkillComponent.result(10, 10, 10, 4, -2, 10, 10, 10) == -1 # modifier only
  end

  test "skill roll: success" do
    assert SkillComponent.result(10, 10, 10, 4, 1, 10, 10, 10) == 2 # all dice below or equal
    assert SkillComponent.result(10, 10, 10, 4, -1, 10, 10, 10) == 1 # negative modifier
    assert SkillComponent.result(10, 10, 10, 4, 6, 10, 10, 10) == 2 # positive modifier
    assert SkillComponent.result(10, 10, 10, 4, 0, 10, 11, 10) == 2 # 1 skill point used
    assert SkillComponent.result(10, 10, 10, 4, 0, 10, 12, 10) == 1 # 2 skill points used
    assert SkillComponent.result(10, 10, 10, 4, 0, 10, 14, 10) == 1 # 4 skill points used
    assert SkillComponent.result(10, 10, 10, 25, 0, 10, 10, 10) == 6 # don't allow quality above 6
  end
end
