defmodule Dsa.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
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
  end
end
