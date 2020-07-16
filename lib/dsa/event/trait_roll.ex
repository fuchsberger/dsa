defmodule Dsa.Event.TraitRoll do
  use Ecto.Schema
  import Ecto.Changeset
  import Dsa.Lists

  schema "trait_rolls" do
    field :trait, :string
    field :level, :integer
    field :w1, :integer
    field :w1b, :integer
    field :modifier, :integer, default: 0
    field :use_be, :boolean, default: false, virtual: true
    field :be, :integer, default: 0
    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group
    timestamps()
  end

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, [:trait, :level, :use_be, :modifier])
    |> validate_required([:trait, :level, :use_be, :modifier])
    |> validate_inclusion(:trait, base_value_options())
    |> validate_number(:level, greater_than_or_equal_to: 5)
    |> validate_number(:modifier, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
  end

  def changeset(roll, attrs, :create) do
    roll
    |> changeset(attrs)
    |> cast(attrs, [:w1, :w1b, :be, :character_id, :group_id])
    |> validate_number(:w1, greater_than_or_equal_to: 1, less_than_or_equal_to: 20)
    |> validate_number(:w1b, greater_than_or_equal_to: 1, less_than_or_equal_to: 20)
    |> validate_number(:be, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
