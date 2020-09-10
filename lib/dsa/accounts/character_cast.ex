defmodule Dsa.Accounts.CharacterCast do
  @moduledoc """
  CharacterCast module
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "character_casts" do
    field :level, :integer, default: 0
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
    belongs_to :cast, Dsa.Lore.Cast, primary_key: true
  end

  @fields ~w(character_id cast_id level)a
  def changeset(character_cast, params \\ %{}) do
    character_cast
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:level, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:cast_id)
    |> unique_constraint([:character_id, :cast_id])
  end
end
