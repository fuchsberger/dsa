defmodule Dsa.Repo.Migrations.AddEventTable do
  use Ecto.Migration

  def change do
    create table(:main_log) do
      add :type, :integer
      add :character_name, :string
      add :left, :string
      add :right, :string
      add :result, :string
      add :roll, :integer
      add :result_type, :integer
      add :character_id, references(:characters)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index(:main_log, :group_id)
  end
end
