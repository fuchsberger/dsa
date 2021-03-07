defmodule Dsa.Repo.Migrations.AddTraitRolls do
  use Ecto.Migration

  def change do
    create table(:trait_rolls) do
      add :trait, :char, size: 2, null: false
      add :modifier, :smallint
      add :dice, :smallint
      add :success, :boolean, null: false
      add :critical, :boolean, null: false
      add :character_id, references(:characters, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index(:trait_rolls, :character_id)
    create index(:trait_rolls, :group_id)
  end
end
