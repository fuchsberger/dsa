defmodule Dsa.Repo.Migrations.CreateAccounts do
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

    create table(:groups) do
      add :name, :string
      add :master_id, references(:users, on_delete: :nilify_all)
      timestamps()
    end

    create index(:groups, :master_id)

    create table(:characters) do
      add :name, :string
      add :profession, :string
      add :visible, :boolean, default: false, null: false

      add :mu, :smallint
      add :kl, :smallint
      add :in, :smallint
      add :ch, :smallint
      add :ff, :smallint
      add :ge, :smallint
      add :ko, :smallint
      add :kk, :smallint

      add :le_max, :smallint
      add :ae_max, :smallint
      add :ke_max, :smallint
      add :le, :smallint
      add :ke, :smallint
      add :ae, :smallint
      add :sk, :smallint
      add :zk, :smallint
      add :sp, :smallint

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:characters, :user_id)

    alter table(:users) do
      add :active_character_id, references(:characters, on_delete: :nilify_all)
      add :group_id, references(:groups, on_delete: :nilify_all)
    end

    create index(:users, :active_character_id)
    create index(:users, :group_id)
  end
end
