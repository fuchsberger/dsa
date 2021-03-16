defmodule Dsa.Repo.Migrations.AddSpellsToCharacters do
  use Ecto.Migration

  import Dsa
  alias Dsa.Data.Spell

  def change do
    #alter table(:characters) do
    #  Enum.each(Spell.fields(), & add(&1, :integer, default: 0))
    #end
  end
end
