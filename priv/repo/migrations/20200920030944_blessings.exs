defmodule Dsa.Repo.Migrations.Blessings do
  use Ecto.Migration

  def change do
    create table(:blessings, primary_key: false) do
      add :id, :integer, primary_key: true
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
    end
    create index :blessings, [:id, :character_id]
  end
end
