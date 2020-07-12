defmodule Dsa.Game.Character do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(name ap species culture profession at pa w2 tp rw be rs le ae ke sk zk aw ini gw sp)a

  @traits ~w(mu kl in ch ff ge ko kk)a

  @close_combat_talents ~w(cc_dolche cc_faecher cc_fechtwaffen cc_hiebwaffen cc_kettenwaffen cc_lanzen cc_peitschen cc_raufen cc_schilde cc_schwerter cc_spiesswaffen cc_stangenwaffen cc_zweihandhiebwaffen cc_zweihandschwerter)a

  @ranged_combat_talents ~w(rc_armbrueste rc_blasrohre rc_boegen rc_diskusse rc_feuerspeien rc_schleudern rc_wurfwaffen)a

  @combat_talents @close_combat_talents ++ @ranged_combat_talents

  @body_talents ~w(ta_fliegen ta_gaukeleien ta_klettern ta_koerperbeherrschung ta_kraftakt ta_reiten ta_schwimmen ta_selbstbeherrschung ta_singen ta_sinnesschaerfe ta_tanzen ta_taschendiebstahl ta_verbergen ta_zechen)a

  @social_talents ~w(ta_bekehren ta_betoeren ta_einschuechtern ta_etikette ta_gassenwissen ta_menschenkenntnis ta_ueberreden ta_verkleiden ta_willenskraft)a

  @nature_talents ~w(ta_faehrtensuchen ta_fesseln ta_fischen ta_orientierung ta_pflanzenkunde ta_tierkunde ta_wildnisleben)a

  @knowledge_talents ~w(ta_brettspiel ta_geographie ta_geschichtswissen ta_goetter ta_kriegskunst ta_magiekunde ta_mechanik ta_rechnen ta_rechtskunde ta_sagen ta_sphaerenkunde ta_sternkunde)a

  @crafting_talents ~w(ta_alchimie ta_boote ta_fahrzeuge ta_handel ta_gift ta_krankheiten ta_seele ta_wunden ta_holz ta_lebensmittel ta_leder ta_malen ta_metall ta_musizieren ta_schloesser ta_stein ta_stoff)a

  @talents @body_talents ++ @social_talents ++ @nature_talents ++ @knowledge_talents ++ @crafting_talents

  @required_fields @fields ++ @traits ++ @combat_talents ++ @talents

  schema "characters" do

    # Generell
    field :name, :string
    field :ap, :integer, default: 1100
    field :species, :string
    field :culture, :string
    field :profession, :string

    # Eigenschaften
    Enum.each(@traits, & field(&1, :integer, default: 8))

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

    # Talents
    Enum.each(@combat_talents, & field(&1, :integer, default: 6))
    Enum.each(@talents, & field(&1, :integer, default: 0))

    belongs_to :group, Dsa.Game.Group
    belongs_to :user, Dsa.Accounts.User

    has_many :character_skills, Dsa.Game.CharacterSkill, on_replace: :delete
    has_many :skills, through: [:character_skills, :skill]

    timestamps()
  end

  def active_changeset(character, attrs) do
    character
    |> cast(attrs, [:id])
    |> validate_required([:id])
  end

  def changeset(character, attrs) do
    character
    |> cast(attrs, @required_fields ++ [:group_id])
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:user_id)
  end

  def changeset_update_skills(character, skills) do
    character
    |> cast(%{}, @fields)
    |> put_assoc(:skills, skills)
  end

  def talents(category \\ nil) do
    case category do
      "Eigenschaften" -> @traits
      "Nahkampf" -> @close_combat_talents
      "Fernkampf" -> @ranged_combat_talents
      "Körper" -> @body_talents
      "Gesellschaft" -> @social_talents
      "Natur" -> @nature_talents
      "Wissen" -> @knowledge_talents
      "Handwerk" -> @crafting_talents
      nil -> @talents
    end
  end
end
