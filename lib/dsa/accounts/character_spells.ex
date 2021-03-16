defmodule Dsa.Accounts.CharacterSpell do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "character_spells" do
    field :level, :integer
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
    belongs_to :spell, Dsa.Data.Spell, primary_key: true
  end

  @fields ~w(level character_id spell_id)a
  def changeset(character_spell, params \\ %{}) do
    character_spell
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:level, greater_than_or_equal_to: 0, less_than: 30)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:spell_id)
    |> unique_constraint([:character_id, :spell_id])
  end
end
