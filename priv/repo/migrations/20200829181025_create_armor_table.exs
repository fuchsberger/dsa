defmodule Elixir.Dsa.Repo.Migrations.CreateArmorTable do
  use Ecto.Migration

  def change do

    alter table(:combat_skills) do
      add :bf, :integer
    end

    create table(:armors) do
      add :name, :string, size: 25
      add :rs, :integer
      add :be, :integer
      add :sw, :integer
      add :penalties, :boolean
    end

    create table(:mweapons) do
      add :name, :string
      add :tp_dice, :integer
      add :tp_bonus, :integer
      add :l1, :string, size: 2
      add :l2, :string, size: 2
      add :ls, :integer
      add :at_mod, :integer
      add :pa_mod, :integer
      add :rw, :integer
      add :combat_skill_id, references(:combat_skills, on_delete: :delete_all), null: false
    end
    create index(:mweapons, [:combat_skill_id])

    create table(:fweapons) do
      add :name, :string
      add :tp_dice, :integer
      add :tp_bonus, :integer
      add :rw1, :integer
      add :rw2, :integer
      add :rw3, :integer
      add :lz, :integer
      add :combat_skill_id, references(:combat_skills, on_delete: :delete_all), null: false
    end
    create index(:fweapons, [:combat_skill_id])

    create table(:special_skills) do
      add :name, :string
      add :ap, :integer
      add :type, :integer
      add :modifier, :integer
    end

    create table(:character_special_skills, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :special_skill_id, references(:special_skills, on_delete: :delete_all), primary_key: true
    end

    create index :character_special_skills, [:character_id, :special_skill_id]

    # Combat Special Skills
    create table(:combat_special_skills, primary_key: false) do
      add :combat_skill_id, references(:combat_skills, on_delete: :delete_all), primary_key: true
      add :special_skill_id, references(:special_skills, on_delete: :delete_all), primary_key: true
    end

    create index :combat_special_skills, [:combat_skill_id, :special_skill_id]

    # Character Armors
    create table(:character_armors, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :armor_id, references(:armors, on_delete: :delete_all), primary_key: true
      add :dmg, :integer
    end
    create index :character_armors, [:character_id, :armor_id]

    # Character Meele Weapons
    create table(:character_mweapons, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :mweapon_id, references(:mweapons, on_delete: :delete_all), primary_key: true
      add :dmg, :integer
    end
    create index :character_mweapons, [:character_id, :mweapon_id]

    # Character Far Distance - Weapons
    create table(:character_fweapons, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :fweapon_id, references(:fweapons, on_delete: :delete_all), primary_key: true
      add :dmg, :integer
    end
    create index :character_fweapons, [:character_id, :fweapon_id]
  end
end
