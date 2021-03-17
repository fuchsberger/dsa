defmodule Dsa.Repo.Migrations.SpellRolls do
  use Ecto.Migration

  def change do
    create table(:spell_rolls) do
      add :roll, :integer
      add :modifier, :smallint
      add :quality, :smallint
      add :critical, :boolean, null: false
      add :character_id, references(:characters, on_delete: :delete_all)
      add :spell_id, references(:spells, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index(:spell_rolls, :character_id)
    create index(:spell_rolls, :spell_id)
    create index(:spell_rolls, :group_id)
  end
end
