defmodule Dsa.Game.CharacterSkill do
  @moduledoc """
  CharacterSkill module
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "character_skills" do
    field :level, :integer, required: true, default: 0

    belongs_to :character, Dsa.Game.Character, primary_key: true
    belongs_to :skill, Dsa.Game.Skill, primary_key: true
  end

  @required_fields ~w(character_id skill_id)a

  def changeset(character_skill, params \\ %{}) do
    character_skill
    |> cast(params, @required_fields ++ [:level])
    |> validate_required(@required_fields)
    |> validate_number(:level, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:skill_id)
    |> unique_constraint([:character, :skill])
  end
end
