defmodule Dsa.Repo.Migrations.CreateUsers do
  use Ecto.Migration

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
      add :meister, references(:users, on_delete: :nilify_all)
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

      # koerper talente
      add :t_fliegen, :integer
      add :t_gaukeleien, :integer
      add :t_klettern, :integer
      add :t_kraftakt, :integer
      add :t_reiten, :integer
      add :t_schwimmen, :integer
      add :t_selbstbeherrschung, :integer
      add :t_singen, :integer
      add :t_sinnesschaerfe, :integer
      add :t_tanzen, :integer
      add :t_taschendiebstahl, :integer
      add :t_verbergen, :integer
      add :t_zechen, :integer

      # gesellschaftstalente
      add :t_bekehren, :integer
      add :t_betoeren, :integer
      add :t_einschuechtern, :integer
      add :t_ettikette, :integer
      add :t_gassenwissen, :integer
      add :t_menschenkenntnis, :integer
      add :t_ueberreden, :integer
      add :t_verkleiden, :integer
      add :t_willenskraft, :integer

      # naturtalente
      add :t_faehrtensuchen, :integer
      add :t_fesseln, :integer
      add :t_fischen, :integer
      add :t_orientierung, :integer
      add :t_pflanzenkunde, :integer
      add :t_tierkunde, :integer
      add :t_wildnisleben, :integer

      # wissenstalente
      add :t_brettspiel, :integer
      add :t_geographie, :integer
      add :t_geschichtswissen, :integer
      add :t_goetter, :integer
      add :t_kriegskunst, :integer
      add :t_magiekunde, :integer
      add :t_mechanik, :integer
      add :t_rechnen, :integer
      add :t_rechtskunde, :integer
      add :t_sagen, :integer
      add :t_sphaerenkunst, :integer
      add :t_sternkunde, :integer

      # handwerkstalente
      add :t_alchimie, :integer
      add :t_boote, :integer
      add :t_fahrzeuge, :integer
      add :t_handel, :integer
      add :t_heilkunde_gift, :integer
      add :t_heilkunde_krankheiten, :integer
      add :t_heilkunde_seele, :integer
      add :t_heilkunde_wunden, :integer
      add :t_holzbearbeitung, :integer
      add :t_lebensmittelbearbeitung, :integer
      add :t_lederbearbeitung, :integer
      add :t_malen, :integer
      add :t_musizieren, :integer
      add :t_schloesserknacken, :integer
      add :t_steinbearbeitung, :integer
      add :t_stoffbearbeitung, :integer

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

    create table(:character_skills) do
      add :character_id, references(:characters, on_delete: :nilify_all), null: false
      add :skill_id, references(:characters, on_delete: :nilify_all), null: false
      add :level, :integer
    end

    create index(:character_skills, [:character_id, :skill_id])
  end
end
