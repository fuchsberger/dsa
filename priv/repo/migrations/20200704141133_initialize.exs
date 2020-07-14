defmodule Dsa.Repo.Migrations.Initialize do
  use Ecto.Migration

  import Dsa.Accounts.Character, only: [talents: 0, talents: 1]

  def change do
    create table(:users) do
      add :name, :string, size: 10
      add :username, :string, size: 15
      add :password_hash, :string
      add :admin, :boolean
      timestamps()
    end

    create unique_index(:users, [:username])

    create table(:groups) do
      add :name, :string, size: 10
      add :master_id, references(:users, on_delete: :nilify_all)
      timestamps()
    end

    create table(:characters) do
      add :name, :string, size: 15
      add :group_id, references(:groups, on_delete: :nilify_all)
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :ap, :integer
      add :species, :string, size: 10
      add :culture, :string, size: 15
      add :profession, :string, size: 15

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
      Enum.each(talents("Eigenschaften"), & add(&1, :integer))
      Enum.each(talents(), & add(&1, :integer))

      timestamps()
    end

    create index(:characters, [:group_id, :user_id])

    create table(:skills) do
      add :name, :string, size: 40
      add :category, :string, size: 15
      add :e1, :string, size: 2
      add :e2, :string, size: 2
      add :e3, :string, size: 2
      add :be, :boolean
      add :sf, :string, size: 1
    end

    create table(:character_skills, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :skill_id, references(:skills, on_delete: :delete_all), primary_key: true
      add :level, :integer
    end

    create index :character_skills, [:character_id]
    create index :character_skills, [:skill_id]
    create unique_index :character_skills, [:character_id, :skill_id]

    create table(:trait_rolls) do
      add :trait, :string, size: 2
      add :level, :integer
      add :w1, :integer
      add :w1b, :integer
      add :be, :integer
      add :modifier, :integer
      add :character_id, references(:characters, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end
    create index :trait_rolls, [:character_id]
    create index :trait_rolls, [:group_id]

    create table(:talent_rolls) do
      add :talent, :string, size: 40
      add :level, :integer
      add :w1, :integer
      add :w2, :integer
      add :w3, :integer
      add :e1, :integer
      add :e2, :integer
      add :e3, :integer
      add :t1, :string, size: 2
      add :t2, :string, size: 2
      add :t3, :string, size: 2
      add :modifier, :integer
      add :be, :integer
      add :character_id, references(:characters, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end
    create index :talent_rolls, [:character_id]
    create index :talent_rolls, [:group_id]

    create table(:logs) do
      add :message, :string
      add :details, :string
      add :character_id, references(:characters, on_delete: :nilify_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index :logs, [:character_id]
    create index :logs, [:group_id]
  end
end
