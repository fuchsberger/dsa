defmodule Dsa.Repo.Migrations.Languages do
  use Ecto.Migration

  def change do
    create table(:languages, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :language_id, :integer, primary_key: true
      add :level, :integer
    end
    create index :languages, [:character_id, :language_id]
  end
end
