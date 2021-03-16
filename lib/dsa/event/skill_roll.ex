defmodule Dsa.Event.SkillRoll do
  use Ecto.Schema

  import Ecto.Changeset

  schema "skill_rolls" do
    field :roll, :integer
    field :modifier, :integer, default: 0
    field :quality, :integer
    field :critical, :boolean

    belongs_to :character, Dsa.Characters.Character
    belongs_to :skill, Dsa.Data.Skill
    belongs_to :group, Dsa.Accounts.Group

    timestamps()
  end

  def changeset(event, params) do
    event
    |> cast(params, [:modifier, :skill_id])
    |> validate_required([:modifier, :skill_id])
    |> validate_number(:modifier, greater_than_or_equal_to: -12, less_than_or_equal_to: 12)
    |> foreign_key_constraint(:skill_id)
  end
end
