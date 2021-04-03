defmodule Dsa.DiceTableEntriesTest do
  use Dsa.DataCase

  alias Dsa.DiceTableEntries

  describe "dice_table_entries" do
    alias Dsa.DiceTableEntries.DiceTableEntry

    @valid_attrs %{dice: 42, text: "some text"}
    @update_attrs %{dice: 43, text: "some updated text"}
    @invalid_attrs %{dice: nil, text: nil}

    def dice_table_entry_fixture(attrs \\ %{}) do
      {:ok, dice_table_entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DiceTableEntries.create_dice_table_entry()

      dice_table_entry
    end

    test "list_dice_table_entries/0 returns all dice_table_entries" do
      dice_table_entry = dice_table_entry_fixture()
      assert DiceTableEntries.list_dice_table_entries() == [dice_table_entry]
    end

    test "get_dice_table_entry!/1 returns the dice_table_entry with given id" do
      dice_table_entry = dice_table_entry_fixture()
      assert DiceTableEntries.get_dice_table_entry!(dice_table_entry.id) == dice_table_entry
    end

    test "create_dice_table_entry/1 with valid data creates a dice_table_entry" do
      assert {:ok, %DiceTableEntry{} = dice_table_entry} = DiceTableEntries.create_dice_table_entry(@valid_attrs)
      assert dice_table_entry.dice == 42
      assert dice_table_entry.text == "some text"
    end

    test "create_dice_table_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DiceTableEntries.create_dice_table_entry(@invalid_attrs)
    end

    test "update_dice_table_entry/2 with valid data updates the dice_table_entry" do
      dice_table_entry = dice_table_entry_fixture()
      assert {:ok, %DiceTableEntry{} = dice_table_entry} = DiceTableEntries.update_dice_table_entry(dice_table_entry, @update_attrs)
      assert dice_table_entry.dice == 43
      assert dice_table_entry.text == "some updated text"
    end

    test "update_dice_table_entry/2 with invalid data returns error changeset" do
      dice_table_entry = dice_table_entry_fixture()
      assert {:error, %Ecto.Changeset{}} = DiceTableEntries.update_dice_table_entry(dice_table_entry, @invalid_attrs)
      assert dice_table_entry == DiceTableEntries.get_dice_table_entry!(dice_table_entry.id)
    end

    test "delete_dice_table_entry/1 deletes the dice_table_entry" do
      dice_table_entry = dice_table_entry_fixture()
      assert {:ok, %DiceTableEntry{}} = DiceTableEntries.delete_dice_table_entry(dice_table_entry)
      assert_raise Ecto.NoResultsError, fn -> DiceTableEntries.get_dice_table_entry!(dice_table_entry.id) end
    end

    test "change_dice_table_entry/1 returns a dice_table_entry changeset" do
      dice_table_entry = dice_table_entry_fixture()
      assert %Ecto.Changeset{} = DiceTableEntries.change_dice_table_entry(dice_table_entry)
    end
  end
end
