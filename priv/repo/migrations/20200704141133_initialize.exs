defmodule Dsa.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  import Dsa.Game.Character, only: [talents: 0]

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string
      add :password_hash, :string
      add :admin, :boolean
      timestamps()
    end

    create unique_index(:users, [:username])

    create table(:groups) do
      add :name, :string
      add :master_id, references(:users, on_delete: :nilify_all)
      timestamps()
    end

    create table(:characters) do
      add :name, :string
      add :group_id, references(:groups, on_delete: :nilify_all)
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :ap, :integer
      add :species, :string
      add :culture, :string
      add :profession, :string

      # eigenschaften
      add :mu, :integer
      add :kl, :integer
      add :in, :integer
      add :ch, :integer
      add :ff, :integer
      add :ge, :integer
      add :ko, :integer
      add :kk, :integer

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

      add :cc_dolche, :integer
      add :cc_faecher, :integer
      add :cc_fechtwaffen, :integer
      add :cc_hiebwaffen, :integer
      add :cc_kettenwaffen, :integer
      add :cc_lanzen, :integer
      add :cc_peitschen, :integer
      add :cc_raufen, :integer
      add :cc_schilde, :integer
      add :cc_schwerter, :integer
      add :cc_spiesswaffen, :integer
      add :cc_stangenwaffen, :integer
      add :cc_zweihandhiebwaffen, :integer
      add :cc_zweihandschwerter, :integer

      # ranged combat
      add :rc_armbrueste, :integer
      add :rc_blasrohre, :integer
      add :rc_boegen, :integer
      add :rc_diskusse, :integer
      add :rc_feuerspeien, :integer
      add :rc_schleudern, :integer
      add :rc_wurfwaffen, :integer

      # talents
      Enum.each(talents(), & add(&1, :integer))

      timestamps()
    end

    create index(:characters, [:group_id, :user_id])

    create table(:skills) do
      add :name, :string
      add :category, :string
      add :e1, :string
      add :e2, :string
      add :e3, :string
      add :be, :boolean
    end

    create table(:character_skills, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :skill_id, references(:skills, on_delete: :delete_all), primary_key: true
      add :level, :integer
    end

    create index :character_skills, [:character_id]
    create index :character_skills, [:skill_id]
    create unique_index :character_skills, [:character_id, :skill_id]

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
