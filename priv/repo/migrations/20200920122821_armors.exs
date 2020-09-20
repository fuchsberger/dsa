defmodule Dsa.Repo.Migrations.Armors do
  use Ecto.Migration

  def change do
    create table(:armors, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :id, :integer, primary_key: true
      add :dmg, :integer
    end
    create index :armors, [:character_id, :id]
  end
end
