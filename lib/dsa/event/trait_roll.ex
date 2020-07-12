defmodule Dsa.Event.TraitRoll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trait_rolls" do
    field :trait, :string
    field :level, :integer
    field :w1, :integer
    field :w1b, :integer
    field :modifier, :integer, default: 0
    field :use_be, :boolean, default: false, virtual: true
    field :max_be, :integer, virtual: true
    field :be, :integer, default: 0
    belongs_to :character, Dsa.Game.Character
    belongs_to :group, Dsa.Game.Group
  end

  @required_fields ~w(trait level w1 w1b be use_be max_be modifier character_id group_id)a
  def changeset(roll, attrs) do
    roll
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:trait, ["mu", "kl", "in", "ch", "ff", "ge", "ko", "kk"])
    |> validate_number(:level, greater_than_or_equal_to: 5)
    |> validate_number(:w1, greater_than_or_equal_to: 1, less_than_or_equal_to: 20)
    |> validate_number(:w1b, greater_than_or_equal_to: 1, less_than_or_equal_to: 20)
    |> validate_number(:max_be, greater_than_or_equal_to: 0)
    |> validate_number(:modifier, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> put_be()
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end

  defp put_be(changeset) do
    IO.inspect changeset
    if get_change(changeset, :use_be),
      do: put_change(changeset, :be, get_change(changeset, :max_be)),
      else: changeset
  end
end
