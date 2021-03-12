defmodule Dsa.Repo.Migrations.Events do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :data, :map, default: %{}
      add :group_id, references(:groups, on_delete: :nilify_all)
      add :character_id, references(:characters, on_delete: :nilify_all)
      add :type, :integer
      timestamps()
    end

    create index(:logs, :character_id)
    create index(:logs, :group_id)
  end
end
