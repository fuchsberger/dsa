defmodule Dsa.Repo.Migrations.AddBlessingsRoll do
  use Ecto.Migration

  def change do
    create table(:blessing_rolls) do
      add :roll, :integer
      add :modifier, :smallint
      add :quality, :smallint
      add :critical, :boolean, null: false
      add :character_id, references(:characters, on_delete: :delete_all)
      add :blessing_id, references(:blessings, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index(:blessing_rolls, :character_id)
    create index(:blessing_rolls, :blessing_id)
    create index(:blessing_rolls, :group_id)
  end
end
