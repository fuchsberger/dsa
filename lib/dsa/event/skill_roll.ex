defmodule Dsa.Event.SkillRoll do
  use Ecto.Schema

  import Ecto.Changeset

  schema "skill_rolls" do
    field :modifier, :integer, default: 0
    field :dice, Dsa.Type.Dice
    field :quality, :integer
    field :critical, :boolean, default: false
    belongs_to :character, Dsa.Accounts.Character
    belongs_to :skill, Dsa.Data.Skill
    belongs_to :group, Dsa.Accounts.Group
    timestamps()
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:skill_id, :modifier])
    |> validate_required([:skill_id])
    |> validate_number(:modifier, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> foreign_key_constraint(:skill_id)
  end
end
