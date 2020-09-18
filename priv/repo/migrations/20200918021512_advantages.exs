defmodule Dsa.Repo.Migrations.Advantages do
  use Ecto.Migration

  def change do
    create table(:advantages) do
      add :advantage_id, :integer
      add :character_id, references(:characters, on_delete: :delete_all)
      add :level, :integer
      add :details, :string
      add :ap, :integer
    end
    create index :advantages, [:character_id]
  end
end
