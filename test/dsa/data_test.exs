defmodule Dsa.DataTest do
  use Dsa.DataCase

  import Dsa.DataFixtures

  alias Dsa.Data
  alias Dsa.Data.Skill

  describe "list_skills/1" do
    test "returns an empty list if no data is persisted" do
      assert [] =  Data.list_skills()
    end

    test "returns list of entries" do
      %{id: id} = skill_fixture()
      assert [%Skill{id: ^id}] = Data.list_skills()
    end
  end

  describe "create_skill/1" do

    test "with valid data creates a skill" do
      skill_params = valid_skill_attributes()

      assert {:ok, %Skill{} = skill} = Data.create_skill(skill_params)
      assert skill.id == skill_params.id
      assert skill.name == "Skill #{skill_params.id}"
      assert skill.category == :crafting
      assert skill.cost_factor == :c
      assert skill.check == "MU/KL/FF"
      assert skill.applications == ["alchimistische Gifte", "Elixiere", "profane Alchimie"]
      # TODO: verify the remaining fields
    end

    test "with invalid data returns error changeset" do
      invalid_params = valid_skill_attributes(%{id: -1})
      assert {:error, %Ecto.Changeset{}} = Data.create_skill(invalid_params)
    end
  end

  # TODO: add tests for updating skills
end
