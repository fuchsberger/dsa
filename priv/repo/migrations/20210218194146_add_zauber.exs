defmodule Dsa.Repo.Migrations.AddZauber do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      for skill_id <- 61..110 do
        add String.to_atom("t#{skill_id}"), :integer, default: 0
      end
    end
  end
end
