defmodule Dsa.Repo.Migrations.AddCharacterBlessings do
  use Ecto.Migration

  def change do
    create table(:character_blessings, primary_key: false) do
      add :level, :smallint, null: false
      add :character_id, references(:characters, on_delete: :nilify_all), primary_key: true
      add :blessing_id, references(:blessings, on_delete: :nilify_all), primary_key: true
    end

    create index :character_blessings, [:character_id, :blessing_id]
  end
end
