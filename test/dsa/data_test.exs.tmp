defmodule Dsa.DataTest do
  use Dsa.DataCase

  alias Dsa.Data

  describe "skills" do
    alias Dsa.Data.Skill

    @create_attrs %{be: nil, name: "Skill", t1: :mu, t2: :kl, t3: :in, category: :body, sf: :A}
    @update_attrs %{be: true, name: "Skill2", t1: :ff, t2: :ge, t3: :ko, category: :crafting, sf: :B}
    @invalid_attrs %{be: nil, name: nil, t1: nil, t2: nil, t3: nil, category: nil, sf: nil}

    test "list_skills/0 returns all skills in correct order" do
      %Skill{id: id1} = skill_fixture()
      %Skill{id: id2} = skill_fixture(category: :body, name: "A Skill (lower order)")

      skills = Data.list_skills()
      index1 = Enum.find_index(skills, & &1.id == id1)
      index2 = Enum.find_index(skills, & &1.id == id2)

      assert not is_nil(index1)
      assert not is_nil(index2)
      assert index2 < index1
    end

    test "get_skill!/1 returns the spell with given id" do
      %Skill{id: id} = skill_fixture()
      assert %Skill{id: ^id} = Data.get_skill!(id)
    end

    test "create_skill/1 with valid data creates a skill" do
      assert {:ok, %Skill{} = skill} = Data.create_skill(@create_attrs)
      assert skill.be == nil
      assert skill.name == "Skill"
      assert skill.category == 0 # TODO: double check if this should not be :body instead
      assert skill.sf == :A
      assert skill.probe == {:mu, :kl, :in}
    end

    test "create_skill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_skill(@invalid_attrs)
    end

    test "update_skill/1 with valid data updates the skill" do
      skill = skill_fixture()
      assert {:ok, %Skill{} = skill} = Data.update_skill(skill, @update_attrs)
      assert skill.be == true
      assert skill.name == "Skill2"
      assert skill.category == 4 # TODO: double check if this should not be :crafting instead
      assert skill.sf == :B
      assert skill.probe == {:ff, :ge, :ko}
    end

    test "update_skill/1 with invalid data returns error changeset" do
      %Skill{id: id} = skill = skill_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_skill(skill, @invalid_attrs)
      assert %Skill{id: ^id} = Data.get_skill!(id)
    end

    test "delete_skill/1 deletes the skill" do
      skill = skill_fixture()
      assert {:ok, %Skill{id: id}} = Data.delete_skill(skill)
      assert catch_error Data.get_skill!(id)
    end

    test "change_skill/1 returns a skill changeset" do
      skill = skill_fixture()
      assert %Ecto.Changeset{} = Data.change_skill(skill)
    end
  end

  describe "spells" do
    alias Dsa.Data.Spell

    @valid_attrs %{name: "Zauber", spread: [1], sf: :A, t1: :mu, t2: :kl, t3: :in}
    @update_attrs %{name: "Zauber2", ritual: true, sf: :B, spread: [2, 3], t1: :ch, t2: :ko, t3: :kk}
    @invalid_attrs %{name: nil, spread: nil, sf: nil, t1: nil, t2: nil, t3: nil}

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

    test "get_spell!/1 returns the spell with given id" do
      %Spell{id: id} = spell_fixture()
      assert %Spell{id: ^id} = Data.get_spell!(id)
    end

    test "create_spell/1 with valid data creates a spell" do
      assert {:ok, %Spell{} = spell} = Data.create_spell(@valid_attrs)
      assert spell.name == "Zauber"
      assert spell.spread == [1]
      assert spell.sf == :A
      assert spell.probe == {:mu, :kl, :in}
    end

    test "create_spell/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_spell(@invalid_attrs)
    end

    test "update_spell/1 with valid data updates the spell" do
      spell = spell_fixture()
      assert {:ok, %Spell{} = spell} = Data.update_spell(spell, @update_attrs)
      assert spell.name == "Zauber2"
      assert spell.spread == [2, 3]
      assert spell.sf == :B
      assert spell.probe == {:ch, :ko, :kk}
    end

    test "update_spell/1 with invalid data returns error changeset" do
      %Spell{id: id} = spell = spell_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_spell(spell, @invalid_attrs)
      assert %Spell{id: ^id} = Data.get_spell!(id)
    end

    test "delete_spell/1 deletes the spell" do
      spell = spell_fixture()
      assert {:ok, %Spell{id: id}} = Data.delete_spell(spell)
      assert catch_error Data.get_spell!(id)
    end

    test "change_spell/1 returns a spell changeset" do
      spell = spell_fixture()
      assert %Ecto.Changeset{} = Data.change_spell(spell)
    end
  end
end
