defmodule Dsa.Type.CostFactorTest do
  use Dsa.DataCase

  alias Dsa.Type.CostFactor

  test "type/0 should return :integer" do
    assert :integer = CostFactor.type()
  end

  describe "cast/1" do
    test "should return the integer representation for database storage" do
      assert {:ok, :e} = CostFactor.cast("E")
    end

    test "should return error if check is invalid" do
      assert :error = CostFactor.cast("F")
      assert :error = CostFactor.cast(:e)
    end
  end

  test "load/1 should return the check" do
    assert {:ok, :e} = CostFactor.load(4)
  end

  describe "dump/1" do
    test "should return an index if val is atom" do
      assert {:ok, 4} = CostFactor.dump(:e)
    end

    test "should return error if val is invalid" do
      assert :error = CostFactor.dump("E")
    end
  end
end
