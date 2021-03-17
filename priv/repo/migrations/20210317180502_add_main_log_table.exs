defmodule Dsa.Repo.Migrations.AddMainLogTable do
  use Ecto.Migration

  def change do
    create table(:main_log) do
      add :type, :integer
      add :character_name, :string
      add :left, :string
      add :right, :string
      add :character_id, references(:characters)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index(:main_log, :group_id)
  end
end
