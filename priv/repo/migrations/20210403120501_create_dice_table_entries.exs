defmodule Dsa.Repo.Migrations.CreateDiceTableEntries do
  use Ecto.Migration

  def change do
    create table(:dice_table_entries) do
      add :text, :string
      add :dice_table_id, references(:dice_tables, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:dice_table_entries, :dice_table_id)
  end
end
