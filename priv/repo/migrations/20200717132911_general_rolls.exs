defmodule Dsa.Repo.Migrations.GeneralRolls do
  use Ecto.Migration

  def change do
    create table(:general_rolls) do
      add :count, :integer
      add :max, :integer
      add :hidden, :boolean
      add :result, :integer
      add :bonus, :integer
      add :character_id, references(:characters, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index :general_rolls, [:character_id]
    create index :general_rolls, [:group_id]
  end
end
