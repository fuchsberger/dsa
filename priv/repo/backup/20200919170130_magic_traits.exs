defmodule Dsa.Repo.Migrations.MagicTraits do
  use Ecto.Migration

  def change do
    create table(:magic_traits) do
      add :magic_trait_id, :integer
      add :character_id, references(:characters, on_delete: :delete_all)
      add :details, :string
      add :ap, :integer
    end
    create index :magic_traits, [:character_id]
  end
end
