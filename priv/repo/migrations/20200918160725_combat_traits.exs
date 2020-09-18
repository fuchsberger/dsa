defmodule Dsa.Repo.Migrations.CombatTraits do
  use Ecto.Migration

    def change do
      create table(:combat_traits, primary_key: false) do
        add :id, :integer, primary_key: true
        add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      end
      create index :combat_traits, [:id, :character_id]
    end
  end
