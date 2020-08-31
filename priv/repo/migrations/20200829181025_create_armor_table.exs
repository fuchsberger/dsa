defmodule Elixir.Dsa.Repo.Migrations.CreateArmorTable do
  use Ecto.Migration

  def change do
    create table(:armors) do
      add :name, :string, size: 25
      add :rs, :integer
      add :be, :integer
      add :penalties, :boolean
    end

    alter table(:characters) do
      remove :be
      remove :rs
      add :armor_id, references(:armors, on_delete: :nilify_all)
    end

    create index(:characters, [:armor_id])
  end
end
