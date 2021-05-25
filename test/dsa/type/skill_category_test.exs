defmodule Dsa.Type.SkillCategoryTest do
  use Dsa.DataCase

  alias Dsa.Type.SkillCategory

  test "type/0 should return :integer" do
    assert :integer = SkillCategory.type()
  end

  describe "cast/1" do
    test "should return the integer representation for database storage" do
      assert {:ok, :social} = SkillCategory.cast("Gesellschaftstalente")
    end

    test "should return error if check is invalid" do
      assert :error = SkillCategory.cast("Invalid Category")
      assert :error = SkillCategory.cast(:social)
    end
  end

  test "load/1 should return the check" do
    assert {:ok, :social} = SkillCategory.load(1)
  end

  describe "dump/1" do
    test "should return an index if val is atom" do
      assert {:ok, 1} = SkillCategory.dump(:social)
    end

    test "should return error if val is invalid" do
      assert :error = SkillCategory.dump("Gesellschaftstalente")
    end
  end
end
