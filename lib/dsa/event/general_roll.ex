defmodule Dsa.Event.GeneralRoll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "general_rolls" do
    field :count, :integer, default: 1
    field :max, :integer, default: 20
    field :bonus, :integer, default: 0
    field :result, :integer
    field :hidden, :boolean
    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group
    timestamps()
  end

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, [:count, :bonus, :max, :hidden])
    |> validate_required([:count, :bonus, :max, :hidden])
    |> validate_inclusion(:max, [3,6,12,20])
    |> validate_number(:count, greater_than: 0)
    |> validate_number(:bonus, greater_than_or_equal_to: 0)
  end

  def changeset(roll, attrs, :create) do
    roll
    |> changeset(attrs)
    |> cast(attrs, [:result, :character_id, :group_id])
    |> validate_required([:result, :character_id, :group_id])
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
