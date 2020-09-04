defmodule Dsa.Accounts.CharacterArmor do
  @moduledoc """
  CharacterArmor module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "character_armors" do
    field :dmg, :integer, default: 0
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
    belongs_to :armor, Dsa.Lore.Armor, primary_key: true
  end

  def changeset(character_armor, params \\ %{}) do
    character_armor
    |> cast(params, [:character_id, :armor_id, :wear])
    |> validate_required([:character_id, :armor_id])
    |> validate_number(:wear, greater_than_or_equal_to: 0, less_than_or_equal_to: 4)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:armor_id)
    |> unique_constraint([:character, :armor])
  end
end
