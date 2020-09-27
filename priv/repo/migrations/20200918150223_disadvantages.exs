defmodule Dsa.Repo.Migrations.Disadvantages do
  use Ecto.Migration

  def change do
    create table(:disadvantages) do
      add :disadvantage_id, :integer
      add :character_id, references(:characters, on_delete: :delete_all)
      add :details, :string
    end
    create index :disadvantages, [:character_id]
  end
end
