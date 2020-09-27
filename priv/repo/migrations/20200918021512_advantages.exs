defmodule Dsa.Repo.Migrations.Advantages do
  use Ecto.Migration

  def change do
    create table(:advantages, primary_key: false) do
      add :id, :integer, primary_key: true
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
    end
    create index :advantages, [:character_id]
  end
end
