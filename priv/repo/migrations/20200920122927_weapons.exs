defmodule Dsa.Repo.Migrations.Weapons do
  use Ecto.Migration

  def change do
    create table(:mweapons, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :id, :integer, primary_key: true
      add :dmg, :integer
    end
    create index :mweapons, [:character_id, :id]

    create table(:fweapons, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :id, :integer, primary_key: true
      add :dmg, :integer
    end
    create index :fweapons, [:character_id, :id]
  end
end
