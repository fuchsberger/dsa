# defmodule Dsa.DataTest do
#   use Dsa.DataCase

#   alias Dsa.Data

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
# end
