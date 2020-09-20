defmodule Dsa.Repo.Migrations.Logs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :group_id, references(:groups, on_delete: :nilify_all)
      add :character_id, references(:characters, on_delete: :nilify_all)
      add :type, :integer
      add :x1, :integer
      add :x2, :integer
      add :x3, :integer
      add :x4, :integer
      add :x5, :integer
      add :x6, :integer
      add :x7, :integer
      add :x8, :integer
      add :x9, :integer
      add :x10, :integer
      add :x11, :integer
      add :x12, :integer
      timestamps()
    end
    create index :logs, [:character_id, :group_id]
  end
end
