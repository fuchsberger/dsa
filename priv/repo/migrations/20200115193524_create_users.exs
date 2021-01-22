defmodule Dsa.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :username, :string
      add :password_hash, :string
      add :admin, :boolean
      add :confirmed, :boolean
      add :reset, :boolean
      add :token, :string, size: 64
      timestamps()
    end

    create unique_index(:users, :email)
  end
end
