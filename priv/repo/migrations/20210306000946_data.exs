defmodule Dsa.Repo.Migrations.Data do
  use Ecto.Migration

  def up do
    create table(:skills) do
      add :name, :string, null: false
      add :be, :boolean
      add :sf, :char, size: 1
      add :category, :smallint
      add :probe, :smallint
    end
    create unique_index(:skills, :name)

    create table(:blessings) do
      add :name, :string, null: false
      add :sf, :char, size: 1
      add :probe, :smallint
      add :ceremony, :boolean, null: false
      add :cast_time, :smallint
      add :cost, :smallint
    end
    create unique_index(:blessings, :name)

    create table(:spells) do
      add :name, :string
      add :sf, :char, size: 1
      add :probe, :smallint
      add :ritual, :boolean, null: false
      add :spread, {:array, :smallint}
    end

    create unique_index(:spells, [:name])

    flush()
    Dsa.Data.Seeder.seed()
  end

  def down do
    drop index(:skills, :name)
    drop table(:skills)

    drop index(:blessings, :name)
    drop table(:blessings)

    drop index(:spells, [:name])
    drop table(:spells)
  end
end
