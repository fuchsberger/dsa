defmodule Dsa.Repo.Migrations.CreateCombatSets do
  use Ecto.Migration

  def change do
    create table(:combat_sets) do
      add :name, :string
      add :at, :smallint
      add :pa, :smallint
      add :tp_dice, :smallint
      add :tp_bonus, :smallint
      add :tp_type, :smallint
      add :character_id, references(:characters, on_delete: :delete_all), nil: false

      timestamps()
    end

    create index(:combat_sets, [:character_id])

    alter table(:characters) do
      add :ini, :smallint
    end
  end
end
