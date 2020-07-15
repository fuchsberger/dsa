defmodule Dsa.Accounts.Character do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(name ap species culture profession at pa w2 tp rw be rs le ae ke sk zk aw ini gw sp)a

  @base_values ~w(MU KL IN CH FF GE KO KK)

  @close_combat_talents ~w(cc_dolche cc_faecher cc_fechtwaffen cc_hiebwaffen cc_kettenwaffen cc_lanzen cc_peitschen cc_raufen cc_schilde cc_schwerter cc_spiesswaffen cc_stangenwaffen cc_zweihandhiebwaffen cc_zweihandschwerter)a

  @ranged_combat_talents ~w(rc_armbrueste rc_blasrohre rc_boegen rc_diskusse rc_feuerspeien rc_schleudern rc_wurfwaffen)a

  @combat_talents @close_combat_talents ++ @ranged_combat_talents

  @required_fields @fields ++ @base_values ++ @combat_talents

  schema "characters" do

    # Generell
    field :name, :string
    field :ap, :integer, default: 1100
    field :species, :string
    field :culture, :string
    field :profession, :string
    field :monster, :boolean, virtual: true

    # Eigenschaften
    Enum.each(@base_values, & field(&1, :integer, default: 8))

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

    belongs_to :group, Dsa.Accounts.Group
    belongs_to :user, Dsa.Accounts.User

    has_many :character_skills, Dsa.Accounts.CharacterSkill, on_replace: :delete
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
    |> validate_length(:name, min: 2, max: 15)
    |> validate_length(:species, min: 3, max: 10)
    |> validate_length(:culture, min: 3, max: 15)
    |> validate_length(:profession, min: 2, max: 15)
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
      "Kampf" -> @combat_talents
      nil -> @combat_talents
    end
  end
end
