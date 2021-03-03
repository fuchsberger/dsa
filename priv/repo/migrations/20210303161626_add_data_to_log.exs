defmodule Dsa.Repo.Migrations.AddDataToLog do
  use Ecto.Migration

  def change do
    alter table(:logs) do
      add :data, :map, default: %{}
    end
  end
end
