defmodule :"Elixir.Dsa.Repo.Migrations.Small change on general roll table" do
  use Ecto.Migration

  def change do
    alter table(:general_rolls) do
      add :hidden, :boolean
    end

    alter table(:trait_rolls) do
      remove :be
    end
  end
end
