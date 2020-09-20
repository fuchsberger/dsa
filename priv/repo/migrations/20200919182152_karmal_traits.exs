defmodule Dsa.Repo.Migrations.KarmalTraits do
  use Ecto.Migration

  def change do
    create table(:karmal_traits) do
      add :karmal_trait_id, :integer
      add :character_id, references(:characters, on_delete: :delete_all)
      add :details, :string
      add :ap, :integer
    end
    create index :karmal_traits, [:character_id]
  end
end
