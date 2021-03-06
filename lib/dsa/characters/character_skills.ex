defmodule Dsa.Characters.CharacterSkill do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "character_skills" do
    field :level, :integer
    belongs_to :character, Dsa.Characters.Character, primary_key: true
    belongs_to :skill, Dsa.Data.Skill, primary_key: true
  end

  @fields ~w(level character_id skill_id)a
  def changeset(character_skill, params \\ %{}) do
    character_skill
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:level, greater_than_or_equal_to: 0, less_than: 30)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:skill_id)
    |> unique_constraint([:character_id, :skill_id])
  end
end
