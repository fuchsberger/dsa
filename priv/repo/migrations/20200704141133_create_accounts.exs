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
      add :ini, :integer

      # ets relations
      add :species_id, :integer
      add :magic_tradition_id, :integer
      add :karmal_tradition_id, :integer

      # talents
      add :group_id, references(:groups, on_delete: :nilify_all)
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:characters, [:group_id, :user_id])

    # character traits
    create table(:character_traits) do
      add :details, :string
      add :ap, :integer
      add :level, :integer
      add :character_id, references(:characters, on_delete: :delete_all)
      add :trait_id, :integer
    end
    create index :character_traits, [:character_id, :trait_id]

    # character spells
    create table(:character_spells, primary_key: false) do
      add :level, :integer
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :spell_id, :integer, primary_key: true
    end
    create index :character_spells, [:character_id, :spell_id]

      # character prayers
    create table(:character_prayers, primary_key: false) do
      add :level, :integer
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :prayer_id, :integer, primary_key: true
    end
    create index :character_prayers, [:character_id, :prayer_id]

    # character armors
    create table(:character_armors, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :armor_id, :integer, primary_key: true
      add :dmg, :integer
    end
    create index :character_armors, [:character_id, :armor_id]

    # Character Meele Weapons
    create table(:character_mweapons, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :mweapon_id, :integer, primary_key: true
      add :dmg, :integer
    end
    create index :character_mweapons, [:character_id, :mweapon_id]

    # character projectile weapons
    create table(:character_fweapons, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :fweapon_id, :integer, primary_key: true
      add :dmg, :integer
    end
    create index :character_fweapons, [:character_id, :fweapon_id]
  end
end
