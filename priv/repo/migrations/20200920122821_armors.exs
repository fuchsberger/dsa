defmodule Dsa.Repo.Migrations.Armors do
  use Ecto.Migration

  def change do
    create table(:armors) do
      add :character_id, references(:characters, on_delete: :delete_all)
      add :armor_id, :integer
      add :dmg, :integer
    end
    create index :armors, [:character_id]
  end
end
