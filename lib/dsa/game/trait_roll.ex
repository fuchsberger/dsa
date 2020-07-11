defmodule Dsa.Game.TraitRoll do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "trait_rolls" do
    field :trait, :string
    field :modifier, :integer
    belongs_to :character, Dsa.Game.Character
  end

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, [:trait, :modifier, :character_id])
    |> validate_required([:trait, :modifier, :character_id])
    |> validate_inclusion(:trait, ["mu", "kl", "in", "ch", "ff", "ge", "ko", "kk"])
    |> foreign_key_constraint(:character_id)
  end
end
