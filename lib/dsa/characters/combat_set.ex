defmodule Dsa.Characters.CombatSet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "combat_sets" do
    field :name, :string
    field :at, :integer, default: 6
    field :pa, :integer, default: 6
    field :tp_bonus, :integer, default: 0
    field :tp_dice, :integer, default: 1
    field :tp_type, :integer, default: 6

    belongs_to :character, Dsa.Characters.Character

    timestamps()
  end

  @doc false
  @fields [:name, :at, :pa, :tp_dice, :tp_bonus, :tp_type]
  def changeset(combat_set, attrs) do
    combat_set
    |> cast(attrs, @fields)
    |> validate_required([:name])
    |> validate_length(:name, max: 25)
    |> validate_number(:at, greater_than: 0, less_than_or_equal_to: 30)
    |> validate_number(:pa, greater_than: 0, less_than_or_equal_to: 30)
    |> validate_number(:tp_bonus, greater_than_or_equal_to: 0, less_than_or_equal_to: 30)
    |> validate_number(:tp_dice, greater_than_or_equal_to: 0, less_than_or_equal_to: 30)
    |> validate_number(:tp_type, greater_than: 1, less_than_or_equal_to: 20)
  end
end
