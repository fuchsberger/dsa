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

    alter table(:users) do
      add :group_id, references(:groups, on_delete: :nilify_all)
    end
    create index(:users, [:group_id])

    create table(:characters) do

      # general
      add :name, :string
      add :title, :string
      add :height, :float
      add :weight, :integer
      add :origin, :string
      add :birthday, :string
      add :age, :integer
      add :culture, :string
      add :profession, :string

      # base values
      Enum.each(base_values(), & add(&1, :integer))

      # talents
      Enum.each(combat_fields(), & add(&1, :integer))
      Enum.each(talent_fields(), & add(&1, :integer))

      # combat
      add :at, :integer
      add :pa, :integer
      add :tp_dice, :integer
      add :tp_bonus, :integer
      add :be, :integer
      add :rs, :integer

      # stats
      add :le_bonus, :integer
      add :le_lost, :integer
      add :ae_bonus, :integer
      add :ae_lost, :integer
      add :ae_back, :integer
      add :ke_bonus, :integer
      add :ke_lost, :integer
      add :ke_back, :integer

      # overwrites
      add :le, :integer
      add :ke, :integer
      add :ae, :integer
      add :sk, :integer
      add :zk, :integer
      add :ini, :integer
      add :gs, :integer
      add :aw, :integer
      add :sp, :integer

      # ets relations
      add :species_id, :integer
      add :magic_tradition_id, :integer
      add :karmal_tradition_id, :integer

      # talents

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:characters, [:user_id])
  end
end
