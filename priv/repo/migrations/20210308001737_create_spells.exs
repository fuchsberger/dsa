defmodule Dsa.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  alias Dsa.Repo.Seeds.SpellSeeder

  def up do
    create table(:spells) do
      add :name, :string
      add :sf, :char, size: 1
      add :probe, :smallint
      add :traditions, {:array, :smallint}
    end

    create unique_index(:spells, [:name])

    flush()
    SpellSeeder.seed()
  end

  def down do
    drop index(:spells, [:name])
    drop table(:spells)
  end
end
