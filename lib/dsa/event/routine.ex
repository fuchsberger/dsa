defmodule Dsa.Event.Routine do
  use Ecto.Schema
  import Ecto.Changeset

  schema "routine" do
    field :fw, :integer
    field :skill_id, :integer
    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group
    timestamps()
  end

  @fields ~w(fw skill_id character_id group_id)a

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
