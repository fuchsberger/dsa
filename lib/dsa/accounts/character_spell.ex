defmodule Dsa.Accounts.CharacterSpell do
  @moduledoc """
  CharacterCast module
  """
  use Ecto.Schema
  import Dsa.Data, only: [valid_spell?: 1]
  import Ecto.Changeset

  @primary_key false
  schema "character_spells" do
    field :level, :integer, default: 0
    field :spell_id, :integer, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  def changeset(spell, params \\ %{}) do
    spell
    |> cast(params, [:character_id, :spell_id, :level])
    |> validate_required([:character_id, :spell_id])
    |> validate_number(:level, greater_than_or_equal_to: 0)
    |> validate_spell_id()
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :spell_id])
  end

  defp validate_spell_id(changeset) do
    spell_id = get_field(changeset, :spell_id)
    case valid_spell?(spell_id) do
      true -> changeset
      false -> add_error(changeset, :spell_id, "Dieser Zauber existiert nicht.")
    end
  end
end
