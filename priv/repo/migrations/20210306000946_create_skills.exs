defmodule Dsa.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  alias Dsa.Repo.Seeds.SkillSeeder

  def up do
    create table(:skills) do
      add :name, :string
      add :be, :boolean
      add :sf, :char, size: 1
      add :category, :smallint
      add :probe, :smallint
    end

    create unique_index(:skills, [:name])

    flush()
    SkillSeeder.seed()
  end

  def down do
    drop index(:skills, [:name])
    drop table(:skills)
  end
end
