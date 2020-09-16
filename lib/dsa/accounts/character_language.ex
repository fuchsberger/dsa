defmodule Dsa.Accounts.CharacterLanguage do
  @moduledoc """
  CharacterLanguage module
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Dsa.Data.Language

  @primary_key false
  schema "character_languages" do
    field :level, :integer, default: 1
    field :language_id, :integer, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  @fields ~w(character_id language_id level)a
  def changeset(character_language, params \\ %{}) do
    character_language
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:level, greater_than_or_equal_to: 1, less_than_or_equal_to: 4)
    |> validate_number(:language_id, greater_than: 1, less_than_or_equal_to: Language.count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :language_id])
  end
end
