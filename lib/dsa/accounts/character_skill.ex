defmodule Dsa.Accounts.CharacterSkill do
  @moduledoc """
  CharacterSkill module
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "character_skills" do
    field :level, :integer, default: 0
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
    belongs_to :skill, Dsa.Lore.Skill, primary_key: true
  end

  def changeset(character_skill, params \\ %{}) do
    character_skill
    |> cast(params, [:character_id, :skill_id, :level])
    |> validate_required([:character_id, :skill_id])
    |> validate_number(:level, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:skill_id)
    |> unique_constraint([:character, :skill])
  end
end
