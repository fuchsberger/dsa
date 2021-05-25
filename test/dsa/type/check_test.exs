defmodule Dsa.Type.CheckTest do
  use Dsa.DataCase

  alias Dsa.Type.Check

  test "type/0 should return :integer" do
    assert :integer = Check.type()
  end

  describe "cast/1" do
    test "should return a ok tuple if binary" do
      assert {:ok, "KL/KL/IN"} = Check.cast("KL/KL/IN")
    end

    test "should return error if not binary" do
      assert :error = Check.cast({:in, :in, :ch})
    end
  end

  test "load/1 should return the check" do
    assert {:ok, "KL/KL/IN"} = Check.load(74)
  end

  describe "atomize/1" do
    test "should return return a tuple of atoms" do
      assert {:ok, {:kl, :kl, :in}} = Check.atomize("KL/KL/IN")
    end

    test "should return error if check is invalid" do
      assert {:error, :invalid_check} = Check.atomize("IN/VA/LID")
    end
  end

  describe "dump/1" do
    test "should return the integer representation for database storage" do
      assert {:ok, 74} = Check.dump("KL/KL/IN")
    end

    test "should return error if check is invalid" do
      assert :error = Check.dump("IN/VA/LID")
      assert :error = Check.dump({:in, :in, :ch})
    end
  end
end
