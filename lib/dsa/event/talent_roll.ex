defmodule Dsa.Game.TalentRoll do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "talent_rolls" do
    field :modifier, :integer
    belongs_to :character, Dsa.Game.Character
    belongs_to :skill, Dsa.Game.Skill
  end

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, [:modifier, :character_id, :skill_id])
    |> validate_required([:modifier, :character_id, :skill_id])
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:skill_id)
  end
end
