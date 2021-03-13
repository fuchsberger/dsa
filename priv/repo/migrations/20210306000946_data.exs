defmodule Dsa.Repo.Migrations.Data do
  use Ecto.Migration

  alias Dsa.Data.Seeder

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
      add :ceremony, :boolean
      add :cast_time, :smallint
      add :cost, :smallint
    end
    create unique_index(:blessings, :name)

    flush()
    Seeder.seed(:skills)
  end

  def down do
    drop index(:skills, :name)
    drop table(:skills)

    drop index(:blessings, :name)
    drop table(:blessings)
  end
end
