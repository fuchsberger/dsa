defmodule Dsa.Event.TraitRoll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trait_rolls" do
    field :trait, :string
    field :level, :integer
    field :w1, :integer
    field :w1b, :integer
    field :modifier, :integer, default: 0
    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group
    timestamps()
  end

  @fields ~w(trait level w1 w1b modifier character_id group_id)a
  def changeset(roll, attrs) do
    roll
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:trait, ~w(mu kl in ch ff ge ko kk))
    |> validate_number(:modifier, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
  end
end
