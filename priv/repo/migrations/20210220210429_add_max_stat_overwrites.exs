defmodule Dsa.Repo.Migrations.AddMaxStatOverwrites do
  use Ecto.Migration

  def change do
    execute "UPDATE characters SET le=0 WHERE le IS NULL", ""
    execute "UPDATE characters SET ae=0 WHERE ae IS NULL", ""
    execute "UPDATE characters SET ke=0 WHERE ke IS NULL", ""

    alter table(:characters) do
      add :le_max, :integer, default: 0, null: false
      add :ae_max, :integer, default: 0, null: false
      add :ke_max, :integer, default: 0, null: false

      modify :le, :integer, default: 0, null: false, from: :integer
      modify :ae, :integer, default: 0, null: false, from: :integer
      modify :ke, :integer, default: 0, null: false, from: :integer
    end
  end
end
