defmodule Dsa.Type.CheckTest do
  use Dsa.DataCase

  alias Dsa.Type.Check

  describe "cast/1" do
    test "should return the integer representation for database storage" do
      assert {:ok, 74} = Check.cast("KL/KL/IN")
    end

    test "should return error if check is invalid" do
      assert :error = Check.cast("IN/VA/LID")
      assert :error = Check.cast({:in, :in, :ch})
    end
  end

  describe "load/1" do
    setup do
      %{data: 74}
    end

    test "should return the check", %{data: data} do
      assert {:ok, "KL/KL/IN"} = Check.load(data)
    end
  end

  describe "atomize/1" do
    test "should return return a tuple of atoms" do
      assert {:ok, {:kl, :kl, :in}} = Check.atomize("KL/KL/IN")
    end

    test "should return error if check is invalid" do
      assert {:error, :invalid_check} = Check.atomize("IN/VA/LID")
    end
  end
end
