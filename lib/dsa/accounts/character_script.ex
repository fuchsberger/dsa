defmodule Dsa.Accounts.CharacterScript do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Dsa.Data.Script

  @primary_key false
  schema "character_scripts" do
    field :script_id, :integer, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  @fields ~w(character_id script_id)a
  def changeset(character_script, params \\ %{}) do
    character_script
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:script_id, greater_than: 0, less_than_or_equal_to: Script.count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :script_id])
  end
end
