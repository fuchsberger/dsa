defmodule Dsa.Repo.Migrations.CharacterAddVisible do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :visible, :boolean, default: false, null: false
    end
  end
end
