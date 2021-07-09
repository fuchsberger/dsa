defmodule Dsa.Repo.Migrations.AddActiveCombatSet do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :active_combat_set_id, references(:combat_sets, on_delete: :nilify_all)
    end
  end
end
