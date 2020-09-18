defmodule Dsa.Repo.Migrations.Scripts do
  use Ecto.Migration

  def change do
    create table(:scripts, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :script_id, :integer, primary_key: true
    end
    create index :scripts, [:character_id, :script_id]
  end
end
