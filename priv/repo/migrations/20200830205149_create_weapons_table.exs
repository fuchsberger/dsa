defmodule Dsa.Repo.Migrations.CreateWeaponsTable do
  use Ecto.Migration

  def change do
    create table(:weapons) do
      add :name, :string
      add :tp_dice, :integer
      add :tp_bonus, :integer
      add :l1, :string, size: 2
      add :l2, :string, size: 2
      add :ls, :integer
      add :at_mod, :integer
      add :pa_mod, :integer
      add :rw, :integer
      add :rw2, :integer
      add :rw3, :integer
      add :lz, :integer
      add :combat_skill_id, references(:combat_skills, on_delete: :delete_all), null: false
    end
    create index(:weapons, [:combat_skill_id])

    alter table(:characters) do
      add :weapon_id, references(:weapons, on_delete: :nilify_all)
      add :weapon2_id, references(:weapons, on_delete: :nilify_all)
    end

    create index(:characters, [:weapon_id, :weapon2_id])
  end
end
