defmodule Dsa.Repo.Migrations.SpellTricks do
  use Ecto.Migration

  def change do
    create table(:spell_tricks, primary_key: false) do
      add :id, :integer, primary_key: true
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
    end
    create index :spell_tricks, [:id, :character_id]
  end
end
