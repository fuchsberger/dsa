defmodule Dsa.DiceTablesTest do
  use Dsa.DataCase

  alias Dsa.DiceTables

  describe "dice_tables" do
    alias Dsa.DiceTables.DiceTable

    @valid_attrs %{table_name: "some table_name"}
    @update_attrs %{table_name: "some updated table_name"}
    @invalid_attrs %{table_name: nil}

    def dice_table_fixture(attrs \\ %{}) do
      {:ok, dice_table} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DiceTables.create_dice_table()

      dice_table
    end

    test "list_dice_tables/0 returns all dice_tables" do
      dice_table = dice_table_fixture()
      assert Enum.count(DiceTables.list_dice_tables()) > 3
    end

    test "get_dice_table!/1 returns the dice_table with given id" do
      dice_table = dice_table_fixture()
      assert DiceTables.get_dice_table!(dice_table.id) == dice_table
    end

    test "create_dice_table/1 with valid data creates a dice_table" do
      assert {:ok, %DiceTable{} = dice_table} = DiceTables.create_dice_table(@valid_attrs)
      assert dice_table.table_name == "some table_name"
    end

    test "create_dice_table/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DiceTables.create_dice_table(@invalid_attrs)
    end

    test "update_dice_table/2 with valid data updates the dice_table" do
      dice_table = dice_table_fixture()
      assert {:ok, %DiceTable{} = dice_table} = DiceTables.update_dice_table(dice_table, @update_attrs)
      assert dice_table.table_name == "some updated table_name"
    end

    test "update_dice_table/2 with invalid data returns error changeset" do
      dice_table = dice_table_fixture()
      assert {:error, %Ecto.Changeset{}} = DiceTables.update_dice_table(dice_table, @invalid_attrs)
      assert dice_table == DiceTables.get_dice_table!(dice_table.id)
    end

    test "delete_dice_table/1 deletes the dice_table" do
      dice_table = dice_table_fixture()
      assert {:ok, %DiceTable{}} = DiceTables.delete_dice_table(dice_table)
      assert_raise Ecto.NoResultsError, fn -> DiceTables.get_dice_table!(dice_table.id) end
    end

    test "change_dice_table/1 returns a dice_table changeset" do
      dice_table = dice_table_fixture()
      assert %Ecto.Changeset{} = DiceTables.change_dice_table(dice_table)
    end
  end
end
