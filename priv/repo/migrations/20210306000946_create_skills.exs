defmodule Dsa.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  alias Dsa.Repo.Seeds.SkillSeeder

  def up do
    create table(:skills) do
      add :name, :string, null: false
      add :be, :boolean
      add :sf, :char, size: 1, null: false
      add :category, :smallint, null: false
      add :probe, :smallint, null: false
    end

    create unique_index(:skills, :name)

    flush()
    SkillSeeder.seed()
  end

  def down do
    drop index(:skills, :name)
    drop table(:skills)
  end
end
