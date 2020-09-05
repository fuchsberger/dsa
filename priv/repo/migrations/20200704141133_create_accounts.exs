defmodule Dsa.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  import Dsa.Lists

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string
      add :password_hash, :string
      add :admin, :boolean
      timestamps()
    end
    create unique_index(:users, :username)

    create table(:groups) do
      add :name, :string
      add :master_id, references(:users, on_delete: :nilify_all)
      timestamps()
    end
    create index(:groups, :master_id)

    create table(:characters) do
      add :name, :string
      add :species, :string
      add :culture, :string
      add :profession, :string

      # combat
      add :at, :integer
      add :pa, :integer
      add :w2, :boolean
      add :tp, :integer
      add :rw, :integer
      add :be, :integer
      add :rs, :integer

      add :le, :integer
      add :ae, :integer
      add :ke, :integer
      add :sk, :integer
      add :zk, :integer
      add :aw, :integer
      add :ini, :integer
      add :gw, :integer
      add :sp, :integer

      # talents
      Enum.each(base_values(), & add(&1, :integer))
      add :group_id, references(:groups, on_delete: :nilify_all)
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:characters, [:group_id])
    create index(:characters, [:user_id])
  end
end
