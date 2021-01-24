defmodule Dsa.Repo.Migrations.GeneralTraits do
  use Ecto.Migration

  def change do
    create table(:general_traits) do
      add :general_trait_id, :integer
      add :details, :string
      add :character_id, references(:characters, on_delete: :delete_all)
    end
    create index :general_traits, [:character_id]
  end
end
