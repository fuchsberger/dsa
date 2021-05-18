defmodule Dsa.CharactersTest do
  use Dsa.DataCase

  describe "combat_sets" do
    alias Dsa.Characters
    alias Dsa.Characters.CombatSet

    @valid_attrs %{name: "TestSet", at: 10, pa: 10, tp_bonus: 0, tp_dice: 1, tp_type: 6}
    @update_attrs %{name: "TestSet2", at: 11, pa: 11, tp_bonus: 1, tp_dice: 2, tp_type: 7}
    @invalid_attrs %{name: nil, at: nil, pa: nil, tp_bonus: nil, tp_dice: nil, tp_type: nil}

    setup do
      user = user_fixture()
      character = character_fixture(user)
      {:ok, character: character}
    end

    test "list_combat_sets/1 returns all combat_sets", %{character: character} do
      %CombatSet{id: id1} = combat_set_fixture(character)
      assert [%CombatSet{id: ^id1}] = Characters.list_combat_sets(character)
      %CombatSet{id: id2} = combat_set_fixture(character, name: "TestSet2")
      assert [%CombatSet{id: ^id1}, %CombatSet{id: ^id2}] = Characters.list_combat_sets(character)
    end

    test "get_combat_set!/2 returns the combat_set with given id", %{character: character} do
      %CombatSet{id: id} = combat_set_fixture(character)
      assert %CombatSet{id: ^id} = Characters.get_combat_set!(character, id)
    end

    test "create_combat_set/2 with valid data creates a combat_set", %{character: c} do
      assert {:ok, %CombatSet{} = combat_set} = Characters.create_combat_set(c, @valid_attrs)
      assert combat_set.name == "TestSet"
      assert combat_set.at == 10
      assert combat_set.pa == 10
      assert combat_set.tp_bonus == 0
      assert combat_set.tp_dice == 1
      assert combat_set.tp_type == 6
    end

    test "create_combat_set/2 with invalid data returns error changeset", %{character: c} do
      assert {:error, %Ecto.Changeset{}} = Characters.create_combat_set(c, @invalid_attrs)
    end

    test "update_combat_set/2 with valid data updates the combat_set", %{character: c} do
      combat_set = combat_set_fixture(c)
      assert {:ok, %CombatSet{} = combat_set} =
        Characters.update_combat_set(combat_set, @update_attrs)
      assert combat_set.name == "TestSet2"
      assert combat_set.at == 11
      assert combat_set.pa == 11
      assert combat_set.tp_bonus == 1
      assert combat_set.tp_dice == 2
      assert combat_set.tp_type == 7
    end

    test "update_combat_set/2 with invalid data returns error changeset", %{character: c} do
      %CombatSet{id: id} = combat_set = combat_set_fixture(c)
      assert {:error, %Ecto.Changeset{}} =
        Characters.update_combat_set(combat_set, @invalid_attrs)
      assert %CombatSet{id: ^id} = Characters.get_combat_set!(c, id)
    end

    test "delete_combat_set/1 deletes the combat_set", %{character: character} do
      combat_set = combat_set_fixture(character)
      assert {:ok, %CombatSet{}} = Characters.delete_combat_set(combat_set)
      assert Characters.list_combat_sets(character) == []
    end

    test "change_combat_set/1 returns a combat_set changeset", %{character: character} do
      combat_set = combat_set_fixture(character)
      assert %Ecto.Changeset{} = Characters.change_combat_set(combat_set)
    end
  end
end
