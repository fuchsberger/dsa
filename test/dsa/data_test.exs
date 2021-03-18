defmodule Dsa.DataTest do
  use Dsa.DataCase

  alias Dsa.Data

#   describe "skills" do
#     alias Dsa.Data.Skill

#     @valid_attrs %{be: true, name: "some name"}
#     @update_attrs %{be: false, name: "some updated name"}
#     @invalid_attrs %{be: nil, name: nil}

#     def skill_fixture(attrs \\ %{}) do
#       {:ok, skill} =
#         attrs
#         |> Enum.into(@valid_attrs)
#         |> Data.create_skill()

#       skill
#     end

#     test "list_skills/0 returns all skills" do
#       skill = skill_fixture()
#       assert Data.list_skills() == [skill]
#     end

#     test "get_skill!/1 returns the skill with given id" do
#       skill = skill_fixture()
#       assert Data.get_skill!(skill.id) == skill
#     end

#     test "create_skill/1 with valid data creates a skill" do
#       assert {:ok, %Skill{} = skill} = Data.create_skill(@valid_attrs)
#       assert skill.be == true
#       assert skill.name == "some name"
#     end

#     test "create_skill/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Data.create_skill(@invalid_attrs)
#     end

#     test "update_skill/2 with valid data updates the skill" do
#       skill = skill_fixture()
#       assert {:ok, %Skill{} = skill} = Data.update_skill(skill, @update_attrs)
#       assert skill.be == false
#       assert skill.name == "some updated name"
#     end

#     test "update_skill/2 with invalid data returns error changeset" do
#       skill = skill_fixture()
#       assert {:error, %Ecto.Changeset{}} = Data.update_skill(skill, @invalid_attrs)
#       assert skill == Data.get_skill!(skill.id)
#     end

#     test "delete_skill/1 deletes the skill" do
#       skill = skill_fixture()
#       assert {:ok, %Skill{}} = Data.delete_skill(skill)
#       assert_raise Ecto.NoResultsError, fn -> Data.get_skill!(skill.id) end
#     end

#     test "change_skill/1 returns a skill changeset" do
#       skill = skill_fixture()
#       assert %Ecto.Changeset{} = Data.change_skill(skill)
#     end
#   end

  describe "spells" do
    alias Dsa.Data.Spell

    # @valid_attrs %{name: "Zauber", traditions: [1], sf: :A, t1: :mu, t2: :kl, t3: :in}
    # @update_attrs %{name: "Zauber2", ritual: true, sf: :B, traditions: [2, 3], t1: :ch, t2: :ko, t3: :kk}
    # @invalid_attrs %{name: nil, traditions: nil, sf: nil, t1: nil, t2: nil, t3: nil}

    test "list_spells/0 returns all spells in correct order" do
      %Spell{id: id1} = spell_fixture()
      %Spell{id: id2} = spell_fixture(ritual: true, name: "TestSet2")

      spells = Data.list_spells()
      index1 = Enum.find_index(spells, & &1.id == id1)
      index2 = Enum.find_index(spells, & &1.id == id2)

      assert not is_nil(index1)
      assert not is_nil(index2)
      assert index2 < index1
    end

    # test "get_spell!/2 returns the spell with given id", %{character: character} do
    #   %Spell{id: id} = spell_fixture(character)
    #   assert %Spell{id: ^id} = Data.get_spell!(character, id)
    # end

    # test "create_spell/2 with valid data creates a spell", %{character: c} do
    #   assert {:ok, %Spell{} = spell} = Data.create_spell(c, @valid_attrs)
    #   assert spell.name == "TestSet"
    #   assert spell.at == 10
    #   assert spell.pa == 10
    #   assert spell.tp_bonus == 0
    #   assert spell.tp_dice == 1
    #   assert spell.tp_type == 6
    # end

    # test "create_spell/2 with invalid data returns error changeset", %{character: c} do
    #   assert {:error, %Ecto.Changeset{}} = Data.create_spell(c, @invalid_attrs)
    # end

    # test "update_spell/2 with valid data updates the spell", %{character: c} do
    #   spell = spell_fixture(c)
    #   assert {:ok, %Spell{} = spell} =
    #     Data.update_spell(spell, @update_attrs)
    #   assert spell.name == "TestSet2"
    #   assert spell.at == 11
    #   assert spell.pa == 11
    #   assert spell.tp_bonus == 1
    #   assert spell.tp_dice == 2
    #   assert spell.tp_type == 7
    # end

    # test "update_spell/2 with invalid data returns error changeset", %{character: c} do
    #   %Spell{id: id} = spell = spell_fixture(c)
    #   assert {:error, %Ecto.Changeset{}} =
    #     Data.update_spell(spell, @invalid_attrs)
    #   assert %Spell{id: ^id} = Data.get_spell!(c, id)
    # end

    # test "delete_spell/1 deletes the spell", %{character: character} do
    #   spell = spell_fixture(character)
    #   assert {:ok, %Spell{}} = Data.delete_spell(spell)
    #   assert Data.list_spells(character) == []
    # end

    # test "change_spell/1 returns a spell changeset", %{character: character} do
    #   spell = spell_fixture(character)
    #   assert %Ecto.Changeset{} = Data.change_spell(spell)
    # end
  end
end
