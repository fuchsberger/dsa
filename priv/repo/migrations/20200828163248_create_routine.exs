defmodule Dsa.Repo.Migrations.CreateRoutine do
  use Ecto.Migration

  def change do
    create table(:routine) do
      add :fw, :integer
      add :skill_id, references(:skills, on_delete: :delete_all)
      add :character_id, references(:characters, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index :routine, [:skill_id]
    create index :routine, [:character_id]
    create index :routine, [:group_id]
  end
end
