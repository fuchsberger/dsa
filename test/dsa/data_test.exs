defmodule Dsa.DataTest do
  use Dsa.DataCase

  import Dsa.DataFixtures

  alias Dsa.Data
  alias Dsa.Data.Skill

  describe "list_skills/1" do
    test "returns an empty list if no data is persisted" do
      assert [] =  Data.list_skills()
    end

    test "returns list of entries in correct order" do
      %{id: id1} = skill_fixture(%{name: "Skill A", category: "Handwerkstalente"})
      %{id: id2} = skill_fixture(%{name: "Skill C", category: "Naturtalente"})
      %{id: id3} = skill_fixture(%{name: "Skill B", category: "Naturtalente"})
      assert [%Skill{id: ^id3}, %Skill{id: ^id2}, %Skill{id: ^id1}] = Data.list_skills()
    end
  end

  describe "save_skill/1" do

    test "with valid data creates a skill if not exists" do
      %{id: id} = skill_params = valid_skill_attributes()

      assert {:ok, %Skill{} = skill} = Data.save_skill(%Skill{id: id}, skill_params)
      assert skill.id == id
      assert skill.name == "Alchimie"
      assert skill.category == :crafting
      assert skill.cost_factor == :c
      assert skill.check == "MU/KL/FF"
      assert skill.applications == ["alchimistische Gifte", "Elixiere", "profane Alchimie"]
      assert skill.encumbrance_default == true
      assert skill.encumbrance_conditional == nil
      assert skill.tools == "alchimistisches Labor"
      assert skill.quality =~ "bessere Qualität"
      assert skill.failure =~ "misslungen"
      assert skill.success =~ "weiß exakt"
      assert skill.botch =~ "Nebeneffekt"
      assert skill.description =~ "Gestank produzieren."
      assert skill.book == "Basis Regelwerk"
      assert skill.page == 206
    end

    test "with valid data updates a skill if already exists" do
      %{id: id} = skill = skill_fixture()
      updated_params = valid_skill_attributes(%{id: id, name: "Updated Alchimie"})

      assert {:ok, %Skill{} = skill} = Data.save_skill(skill, updated_params)
      assert skill.id == id
      assert skill.name == "Updated Alchimie"
    end

    test "with invalid data does not update a skill if already exists" do
      %{id: id} = skill = skill_fixture()
      invalid_params = valid_skill_attributes(%{id: id, name: nil})

      assert {:error, %Ecto.Changeset{}} = Data.create_skill(invalid_params)
    end

    test "with invalid data returns error changeset" do
      invalid_params = valid_skill_attributes(%{id: -1})
      assert {:error, %Ecto.Changeset{}} = Data.create_skill(invalid_params)
    end
  end
end
