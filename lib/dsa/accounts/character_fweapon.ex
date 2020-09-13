defmodule Dsa.Accounts.CharacterFWeapon do
  @moduledoc """
  CharacterFWeapon module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "character_fweapons" do
    field :dmg, :integer, default: 0
    field :fweapon_id, :integer, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  @fields ~w(character_id fweapon_id dmg)a
  def changeset(character_armor, params \\ %{}) do
    character_armor
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:dmg, greater_than_or_equal_to: 0, less_than_or_equal_to: 4)
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :weapon_id])
  end
end
