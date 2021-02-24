defmodule Dsa.Repo.Migrations.AssociateUsersWithGroups do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :group_id, references(:groups, on_delete: :nilify_all)
    end

    create index(:users, [:group_id])
  end
end
