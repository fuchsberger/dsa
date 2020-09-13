defmodule Dsa.Accounts.CharacterArmor do
  @moduledoc """
  CharacterArmor module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "character_armors" do
    field :dmg, :integer, default: 0
    field :armor_id, :integer, default: 1, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  @fields ~w(armor_id character_id dmg)a
  def changeset(character_armor, params \\ %{}) do
    character_armor
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:dmg, greater_than_or_equal_to: 0, less_than_or_equal_to: 4)
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :armor_id])
  end
end
