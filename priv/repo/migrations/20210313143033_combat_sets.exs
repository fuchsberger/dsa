defmodule Dsa.Repo.Migrations.CombatSets do
  use Ecto.Migration

  def change do
    create table(:combat_sets) do
      add :at, :smallint
      add :pa, :smallint
      add :aw, :smallint
      add :rs, :smallint
      add :be, :smallint
      add :ini, :smallint
      add :gs, :smallint
      add :tp_dice, :smallint
      add :tp_bonus, :smallint

      add :character_id, references(:characters, on_delete: :nilify_all), nil: false
    end

    create index :combat_sets, :character_id
  end
end
