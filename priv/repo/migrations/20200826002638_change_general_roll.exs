defmodule Dsa.Repo.Migrations.ChangeGeneralRoll do
  use Ecto.Migration

  def change do

    rename table(:general_rolls), :count, to: :d1
    rename table(:general_rolls), :result, to: :d2
    rename table(:general_rolls), :bonus, to: :d3

    alter table(:general_rolls) do
      add :d4, :integer
      add :d5, :integer
      remove :hidden
    end
  end
end
