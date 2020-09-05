defmodule Dsa.Repo.Migrations.CreateLore do
  use Ecto.Migration

  def change do
    # combat skills
    create table(:combat_skills) do
      add :name, :string
      add :ranged, :boolean
      add :parade, :boolean
      add :ge, :boolean
      add :kk, :boolean
      add :sf, :string, size: 1
      add :bf, :integer
    end
    create unique_index :combat_skills, :name

    # character combat skills
    create table(:character_combat_skills, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :combat_skill_id, references(:combat_skills, on_delete: :delete_all), primary_key: true
      add :level, :integer
    end
    create index :character_combat_skills, [:character_id, :combat_skill_id]

    # skills
    create table(:skills) do
      add :name, :string
      add :category, :integer
      add :e1, :string, size: 2
      add :e2, :string, size: 2
      add :e3, :string, size: 2
      add :be, :boolean
      add :sf, :string, size: 1
    end
    create unique_index :skills, :name

    # character skills
    create table(:character_skills, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :skill_id, references(:skills, on_delete: :delete_all), primary_key: true
      add :level, :integer
    end
    create index :character_skills, [:character_id, :skill_id]

    # armors
    create table(:armors) do
      add :name, :string
      add :rs, :integer
      add :be, :integer
      add :sw, :integer
      add :penalties, :boolean
    end
    create unique_index :armors, :name

    # Character Armors
    create table(:character_armors, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :armor_id, references(:armors, on_delete: :delete_all), primary_key: true
      add :dmg, :integer
    end
    create index :character_armors, [:character_id, :armor_id]

    # meele weapons
    create table(:mweapons) do
      add :name, :string
      add :tp_dice, :integer
      add :tp_bonus, :integer
      add :ge, :boolean
      add :kk, :boolean
      add :ls, :integer
      add :at_mod, :integer
      add :pa_mod, :integer
      add :rw, :integer
      add :combat_skill_id, references(:combat_skills, on_delete: :delete_all), null: false
    end
    create index(:mweapons, :combat_skill_id)
    create unique_index :mweapons, :name

    # Character Meele Weapons
    create table(:character_mweapons, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :mweapon_id, references(:mweapons, on_delete: :delete_all), primary_key: true
      add :dmg, :integer
    end
    create index :character_mweapons, [:character_id, :mweapon_id]

    # projectile weapons
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
    create index(:fweapons, :combat_skill_id)
    create unique_index :fweapons, :name

    # character projectile weapons
    create table(:character_fweapons, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :fweapon_id, references(:fweapons, on_delete: :delete_all), primary_key: true
      add :dmg, :integer
    end
    create index :character_fweapons, [:character_id, :fweapon_id]

    # special skills
    create table(:special_skills) do
      add :name, :string
      add :ap, :integer
      add :type, :integer
      add :modifier, :integer
    end
    create unique_index :special_skills, :name

    # Combat Special Skills
    create table(:combat_special_skills, primary_key: false) do
      add :combat_skill_id, references(:combat_skills, on_delete: :delete_all), primary_key: true
      add :special_skill_id, references(:special_skills, on_delete: :delete_all), primary_key: true
    end

    create index :combat_special_skills, [:combat_skill_id, :special_skill_id]

    # character special skills
    create table(:character_special_skills, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :special_skill_id, references(:special_skills, on_delete: :delete_all), primary_key: true
    end
    create index :character_special_skills, [:character_id, :special_skill_id]
  end
end