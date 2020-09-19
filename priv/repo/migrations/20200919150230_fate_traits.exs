defmodule Dsa.Repo.Migrations.FateTraits do
  use Ecto.Migration

  def change do
    create table(:fate_traits, primary_key: false) do
      add :id, :integer, primary_key: true
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
    end
    create index :fate_traits, [:id, :character_id]
  end
end
