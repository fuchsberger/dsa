defmodule Dsa.UI.SkillRoll do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dsa.Data.Skill

  @primary_key false

  embedded_schema do
    field :id, :integer
    field :modifier, :integer, default: 0
  end

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, [:id, :modifier])
    |> validate_required([:id])
    |> validate_number(:modifier, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    # TODO do a foreign key constraint on the skill once relationally saved and remove below:
    |> validate_number(:id, greater_than: 0, less_than_or_equal_to: Skill.count())
  end
end
