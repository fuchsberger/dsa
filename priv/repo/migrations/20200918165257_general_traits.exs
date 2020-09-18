defmodule Dsa.Repo.Migrations.GeneralTraits do
  use Ecto.Migration

  def change do
    create table(:general_traits, primary_key: false) do
      add :id, :integer, primary_key: true
      add :ap, :integer
      add :details, :string
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
    end
    create index :general_traits, [:id, :character_id]
  end
end
