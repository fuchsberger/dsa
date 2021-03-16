defmodule Dsa.Event.TraitRoll do
  use Ecto.Schema

  import Ecto.Changeset
  import DsaWeb.DsaHelpers, only: [traits: 0]

  schema "trait_rolls" do
    field :roll, :integer
    field :trait, Ecto.Enum, values: traits()
    field :modifier, :integer, default: 0
    field :success, :boolean, default: false
    field :critical, :boolean, default: false
    belongs_to :character, Dsa.Characters.Character
    belongs_to :group, Dsa.Accounts.Group
    timestamps()
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:trait, :modifier])
    |> validate_required([:trait])
    |> validate_inclusion(:trait, traits())
    |> validate_number(:modifier, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
  end
end
