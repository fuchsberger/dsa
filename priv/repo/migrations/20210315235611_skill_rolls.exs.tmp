defmodule Dsa.Repo.Migrations.SkillRolls do
  use Ecto.Migration

  def change do
    create table(:skill_rolls) do
      add :roll, :integer
      add :modifier, :smallint
      add :quality, :smallint
      add :critical, :boolean, null: false
      add :character_id, references(:characters, on_delete: :delete_all)
      add :skill_id, references(:skills, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index(:skill_rolls, :character_id)
    create index(:skill_rolls, :skill_id)
    create index(:skill_rolls, :group_id)
  end
end
