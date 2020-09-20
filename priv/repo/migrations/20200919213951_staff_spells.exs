defmodule Dsa.Repo.Migrations.StaffSpells do
  use Ecto.Migration

  def change do
    create table(:staff_spells, primary_key: false) do
      add :id, :integer, primary_key: true
      add :details, :string
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
    end
    create index :staff_spells, [:id, :character_id]
  end
end
