defmodule Dsa.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do

    # General Rolls
    create table(:general_rolls) do
      add :d1, :integer
      add :d2, :integer
      add :d3, :integer
      add :d4, :integer
      add :d5, :integer
      add :max, :integer
      add :hidden, :boolean
      add :character_id, references(:characters, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index :general_rolls, :character_id
    create index :general_rolls, :group_id

    # Trait Rolls
    create table(:trait_rolls) do
      add :trait, :string, size: 2
      add :level, :integer
      add :w1, :integer
      add :w1b, :integer
      add :modifier, :integer
      add :character_id, references(:characters, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end
    create index :trait_rolls, :character_id
    create index :trait_rolls, :group_id

    # Talent Rolls
    create table(:talent_rolls) do
      add :level, :integer
      add :w1, :integer
      add :w2, :integer
      add :w3, :integer
      add :t1, :integer
      add :t2, :integer
      add :t3, :integer
      add :e1, :string, size: 2
      add :e2, :string, size: 2
      add :e3, :string, size: 2
      add :modifier, :integer
      add :be, :integer
      add :character_id, references(:characters, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      add :skill_id, references(:skills, on_delete: :delete_all)
      timestamps()
    end
    create index :talent_rolls, :character_id
    create index :talent_rolls, :group_id

    # Logs
    create table(:logs) do
      add :message, :string
      add :details, :string
      add :character_id, references(:characters, on_delete: :nilify_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index :logs, :character_id
    create index :logs, :group_id

    # Routine
    create table(:routine) do
      add :fw, :integer
      add :skill_id, references(:skills, on_delete: :delete_all)
      add :character_id, references(:characters, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)
      timestamps()
    end

    create index :routine, :skill_id
    create index :routine, :character_id
    create index :routine, :group_id
  end
end
