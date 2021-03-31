defmodule Dsa.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :master_id, references(:users, on_delete: :nilify_all)
      timestamps()
    end

    create index(:groups, :master_id)

    alter table(:users) do
      add :group_id, references(:groups, on_delete: :nilify_all)
    end

    create index(:users, :group_id)
  end
end
