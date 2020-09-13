defmodule Dsa.Accounts.CharacterSkill do
  @moduledoc """
  CharacterSkill module
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "character_skills" do
    field :level, :integer, default: 0
    field :skill_id, :integer, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  @fields ~w(character_id skill_id level)a
  def changeset(character_skill, params \\ %{}) do
    character_skill
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:level, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :skill_id])
  end
end
