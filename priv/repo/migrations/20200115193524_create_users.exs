defmodule Dsa.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :username, :string
      add :password_hash, :string
      add :admin, :boolean
      timestamps()
    end

    create unique_index(:users, :email)
    create unique_index(:users, :username)
  end
end