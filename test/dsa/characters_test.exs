defmodule Dsa.CharactersTest do
  use Dsa.DataCase

  alias Dsa.Characters

  describe "combat_sets" do
    alias Dsa.Characters.CombatSet

    @valid_attrs %{at: 42, aw: 42, base_ini: 42, be: 42, gs: 42, pa: 42, rs: 42, tp_bonus: 42, tp_dice: 42}
    @update_attrs %{at: 43, aw: 43, base_ini: 43, be: 43, gs: 43, pa: 43, rs: 43, tp_bonus: 43, tp_dice: 43}
    @invalid_attrs %{at: nil, aw: nil, base_ini: nil, be: nil, gs: nil, pa: nil, rs: nil, tp_bonus: nil, tp_dice: nil}

    def combat_set_fixture(attrs \\ %{}) do
      {:ok, combat_set} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Characters.create_combat_set()

      combat_set
    end

    test "list_combat_sets/0 returns all combat_sets" do
      combat_set = combat_set_fixture()
      assert Characters.list_combat_sets() == [combat_set]
    end

    test "get_combat_set!/1 returns the combat_set with given id" do
      combat_set = combat_set_fixture()
      assert Characters.get_combat_set!(combat_set.id) == combat_set
    end

    test "create_combat_set/1 with valid data creates a combat_set" do
      assert {:ok, %CombatSet{} = combat_set} = Characters.create_combat_set(@valid_attrs)
      assert combat_set.at == 42
      assert combat_set.aw == 42
      assert combat_set.base_ini == 42
      assert combat_set.be == 42
      assert combat_set.gs == 42
      assert combat_set.pa == 42
      assert combat_set.rs == 42
      assert combat_set.tp_bonus == 42
      assert combat_set.tp_dice == 42
    end

    test "create_combat_set/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Characters.create_combat_set(@invalid_attrs)
    end

    test "update_combat_set/2 with valid data updates the combat_set" do
      combat_set = combat_set_fixture()
      assert {:ok, %CombatSet{} = combat_set} = Characters.update_combat_set(combat_set, @update_attrs)
      assert combat_set.at == 43
      assert combat_set.aw == 43
      assert combat_set.base_ini == 43
      assert combat_set.be == 43
      assert combat_set.gs == 43
      assert combat_set.pa == 43
      assert combat_set.rs == 43
      assert combat_set.tp_bonus == 43
      assert combat_set.tp_dice == 43
    end

    test "update_combat_set/2 with invalid data returns error changeset" do
      combat_set = combat_set_fixture()
      assert {:error, %Ecto.Changeset{}} = Characters.update_combat_set(combat_set, @invalid_attrs)
      assert combat_set == Characters.get_combat_set!(combat_set.id)
    end

    test "delete_combat_set/1 deletes the combat_set" do
      combat_set = combat_set_fixture()
      assert {:ok, %CombatSet{}} = Characters.delete_combat_set(combat_set)
      assert_raise Ecto.NoResultsError, fn -> Characters.get_combat_set!(combat_set.id) end
    end

    test "change_combat_set/1 returns a combat_set changeset" do
      combat_set = combat_set_fixture()
      assert %Ecto.Changeset{} = Characters.change_combat_set(combat_set)
    end
  end
end
