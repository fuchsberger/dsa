defmodule Dsa.Accounts.CharacterPrayer do
  @moduledoc """
  CharacterCast module
  """
  use Ecto.Schema
  import Dsa.Data, only: [valid_prayer?: 1]
  import Ecto.Changeset

  @primary_key false
  schema "character_prayers" do
    field :level, :integer, default: 0
    field :prayer_id, :integer, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  def changeset(prayer, params \\ %{}) do
    prayer
    |> cast(params, [:character_id, :prayer_id, :level])
    |> validate_required([:character_id, :prayer_id])
    |> validate_number(:level, greater_than_or_equal_to: 0)
    |> validate_prayer_id()
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :prayer_id])
  end

  defp validate_prayer_id(changeset) do
    prayer_id = get_field(changeset, :prayer_id)
    case valid_prayer?(prayer_id) do
      true -> changeset
      false -> add_error(changeset, :prayer_id, "Diese Liturgie existiert nicht.")
    end
  end
end
