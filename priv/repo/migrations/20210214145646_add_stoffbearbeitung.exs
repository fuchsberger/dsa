defmodule Dsa.Repo.Migrations.AddStoffbearbeitung do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :t59, :integer
    end
  end
end
