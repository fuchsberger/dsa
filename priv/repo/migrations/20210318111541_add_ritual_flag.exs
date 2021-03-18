defmodule Dsa.Repo.Migrations.AddRitualFlag do
  use Ecto.Migration

  def change do
    alter table(:spells) do
      add :ritual, :boolean, default: false, null: false
    end
  end
end
