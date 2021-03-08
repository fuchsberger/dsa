defmodule Dsa.Repo.Migrations.AddBlessings do
  use Ecto.Migration

  alias Dsa.Repo.Seeds.BlessingSeeder

  def up do
    create table(:blessings) do

      add :name, :string, null: false
      add :sf, :char, size: 1, null: false
      add :probe, :smallint, null: false
      add :ceremony, :boolean, null: false
      add :cast_time, :smallint # in actions (blessing) or minutes (ceremony)
      add :cost, :smallint # initial cost only

      # TODO: Perhaps implement later
      # add :category, :string
      # add :duration, :smallint
      # add :range, :smallint
      # add :target, :string
    end

    create unique_index(:blessings, :name)

    flush()
    BlessingSeeder.seed()
  end

  def down do
    drop index(:blessings, :name)
    drop table(:blessings)
  end
end
