defmodule Dsa.Repo.Migrations.Prayers do
  use Ecto.Migration

  def change do
    create table(:prayers, primary_key: false) do
      add :id, :integer, primary_key: true
      add :level, :integer
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
    end
    create index :prayers, [:character_id, :id]
  end
end
