defmodule Dsa.Logs.SpellRoll do
  use Ecto.Schema

  import Ecto.Changeset

  schema "spell_rolls" do
    field :roll, :integer
    field :modifier, :integer, default: 0
    field :quality, :integer
    field :critical, :boolean

    belongs_to :character, Dsa.Characters.Character
    belongs_to :spell, Dsa.Data.Spell
    belongs_to :group, Dsa.Accounts.Group

    timestamps()
  end

  def changeset(event, params) do
    event
    |> cast(params, [:modifier, :spell_id])
    |> validate_required([:modifier, :spell_id])
    |> validate_number(:modifier, greater_than_or_equal_to: -12, less_than_or_equal_to: 12)
    |> foreign_key_constraint(:spell_id)
  end
end
