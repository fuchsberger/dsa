defmodule Dsa.Game.Character do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(name ap species culture profession mu kl in ch ff ge ko kk at pa w2 tp rw be rs le ae ke sk zk aw ini gw sp t_fliegen t_gaukeleien t_klettern t_kraftakt t_reiten t_schwimmen t_selbstbeherrschung t_singen t_sinnesschaerfe t_tanzen t_taschendiebstahl t_verbergen t_zechen t_bekehren t_betoeren t_einschuechtern t_ettikette t_gassenwissen t_menschenkenntnis t_ueberreden t_verkleiden t_willenskraft t_faehrtensuchen t_fesseln t_fischen t_orientierung t_pflanzenkunde t_tierkunde t_wildnisleben t_brettspiel t_geographie t_geschichtswissen t_goetter t_kriegskunst t_magiekunde t_mechanik t_rechnen t_rechtskunde t_sagen t_sphaerenkunst t_sternkunde t_alchimie t_boote t_fahrzeuge t_handel t_heilkunde_gift t_heilkunde_krankheiten t_heilkunde_seele t_heilkunde_wunden t_holzbearbeitung t_lebensmittelbearbeitung t_lederbearbeitung t_malen t_musizieren t_schloesserknacken t_steinbearbeitung t_stoffbearbeitung)a

  schema "characters" do

    # Generell
    field :name, :string
    field :ap, :integer, default: 1100
    field :species, :string
    field :culture, :string
    field :profession, :string

    # Eigenschaften
    field :mu, :integer, default: 8
    field :kl, :integer, default: 8
    field :in, :integer, default: 8
    field :ch, :integer, default: 8
    field :ff, :integer, default: 8
    field :ge, :integer, default: 8
    field :ko, :integer, default: 8
    field :kk, :integer, default: 8

    # combat
    field :at, :integer, default: 5
    field :pa, :integer, default: 5
    field :w2, :boolean, default: false
    field :tp, :integer, default: 2
    field :rw, :integer, default: 1
    field :be, :integer, default: 0
    field :rs, :integer, default: 0

    # stats
    field :le, :integer, default: 30
    field :ae, :integer, default: 0
    field :ke, :integer, default: 0
    field :sk, :integer, default: 0
    field :zk, :integer, default: 0
    field :aw, :integer, default: 4
    field :ini, :integer, default: 8
    field :gw, :integer, default: 8
    field :sp, :integer, default: 3

    # koerper talente
    field :t_fliegen, :integer
    field :t_gaukeleien, :integer
    field :t_klettern, :integer
    field :t_kraftakt, :integer
    field :t_reiten, :integer
    field :t_schwimmen, :integer
    field :t_selbstbeherrschung, :integer
    field :t_singen, :integer
    field :t_sinnesschaerfe, :integer
    field :t_tanzen, :integer
    field :t_taschendiebstahl, :integer
    field :t_verbergen, :integer
    field :t_zechen, :integer

    # gesellschaftstalente
    field :t_bekehren, :integer
    field :t_betoeren, :integer
    field :t_einschuechtern, :integer
    field :t_ettikette, :integer
    field :t_gassenwissen, :integer
    field :t_menschenkenntnis, :integer
    field :t_ueberreden, :integer
    field :t_verkleiden, :integer
    field :t_willenskraft, :integer

    # naturtalente
    field :t_faehrtensuchen, :integer
    field :t_fesseln, :integer
    field :t_fischen, :integer
    field :t_orientierung, :integer
    field :t_pflanzenkunde, :integer
    field :t_tierkunde, :integer
    field :t_wildnisleben, :integer

    # wissenstalente
    field :t_brettspiel, :integer
    field :t_geographie, :integer
    field :t_geschichtswissen, :integer
    field :t_goetter, :integer
    field :t_kriegskunst, :integer
    field :t_magiekunde, :integer
    field :t_mechanik, :integer
    field :t_rechnen, :integer
    field :t_rechtskunde, :integer
    field :t_sagen, :integer
    field :t_sphaerenkunst, :integer
    field :t_sternkunde, :integer

    # handwerkstalente
    field :t_alchimie, :integer
    field :t_boote, :integer
    field :t_fahrzeuge, :integer
    field :t_handel, :integer
    field :t_heilkunde_gift, :integer
    field :t_heilkunde_krankheiten, :integer
    field :t_heilkunde_seele, :integer
    field :t_heilkunde_wunden, :integer
    field :t_holzbearbeitung, :integer
    field :t_lebensmittelbearbeitung, :integer
    field :t_lederbearbeitung, :integer
    field :t_malen, :integer
    field :t_musizieren, :integer
    field :t_schloesserknacken, :integer
    field :t_steinbearbeitung, :integer
    field :t_stoffbearbeitung, :integer

    belongs_to :user, Dsa.Accounts.User
    many_to_many :skills, Dsa.Game.Skill, join_through: Dsa.Game.CharacterSkill

    timestamps()
  end

  def changeset(character, attrs) do
    character
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
