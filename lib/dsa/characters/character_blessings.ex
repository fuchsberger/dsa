defmodule Dsa.Characters.CharacterBlessing do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "character_blessings" do
    field :level, :integer
    belongs_to :character, Dsa.Characters.Character, primary_key: true
    belongs_to :blessing, Dsa.Data.Blessing, primary_key: true
  end

  @fields ~w(level character_id blessing_id)a
  def changeset(character_blessing, params \\ %{}) do
    character_blessing
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:level, greater_than_or_equal_to: 0, less_than: 30)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:blessing_id)
    |> unique_constraint([:character_id, :blessing_id])
  end
end
