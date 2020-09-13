defmodule Dsa.Accounts.CharacterTrait do
  @moduledoc """
  CharacterArmor module
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "character_traits" do
    field :ap, :integer
    field :level, :integer
    field :details, :string
    field :trait_id, :integer
    belongs_to :character, Dsa.Accounts.Character
  end

  @fields ~w(character_id trait_id ap level)a
  def changeset(character_trait, params \\ %{}) do
    character_trait
    |> cast(params, [:details | @fields])
    |> validate_required(@fields)
    |> validate_length(:details, max: 50)
    |> validate_number(:ap, not_equal_to: 0)
    |> foreign_key_constraint(:character_id)
  end
end
