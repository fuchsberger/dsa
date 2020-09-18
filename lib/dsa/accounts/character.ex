defmodule Dsa.Accounts.Character do
  use Ecto.Schema
  import Ecto.Changeset
  import Dsa.Lists
  import DsaWeb.CharacterHelpers

  alias Dsa.Data.{Advantage, Language, Script}
  alias Dsa.Accounts.{Group, User, CharacterArmor, CharacterFWeapon, CharacterMWeapon, CharacterTrait, CharacterSpell, CharacterPrayer}

  schema "characters" do

    # general
    field :name, :string, default: "Held"

    # base traits
    Enum.each(base_values(), & field(&1, :integer, default: 8))

    # talents
    Enum.each(combat_fields(), & field(&1, :integer, default: 6))
    Enum.each(talent_fields(), & field(&1, :integer, default: 0))

    # combat
    field :at, :integer, default: 5
    field :pa, :integer, default: 5
    field :tp_dice, :integer, default: 1
    field :tp_bonus, :integer, default: 2
    field :be, :integer, default: 0
    field :rs, :integer, default: 0

    # stats
    field :le_bonus, :integer, default: 0
    field :le_lost, :integer, default: 0
    field :ae_bonus, :integer, default: 0
    field :ae_lost, :integer, default: 0
    field :ae_back, :integer, default: 0
    field :ke_bonus, :integer, default: 0
    field :ke_lost, :integer, default: 0
    field :ke_back, :integer, default: 0

    # overwrites
    field :le, :integer
    field :ke, :integer
    field :ae, :integer
    field :sk, :integer
    field :zk, :integer
    field :ini, :integer
    field :gs, :integer
    field :aw, :integer
    field :sp, :integer

    # ets relations
    field :species_id, :integer, default: 1
    field :magic_tradition_id, :integer
    field :karmal_tradition_id, :integer

    # virtual fields for adding various information
    field :advantage_id, :integer, virtual: true
    field :language_id, :integer, virtual: true
    field :script_id, :integer, virtual: true

    field :trait_id, :integer, virtual: true
    field :trait_level, :integer, virtual: true
    field :trait_ap, :integer, virtual: true
    field :trait_details, :string, virtual: true
    field :spell_id, :integer, virtual: true
    field :prayer_id, :integer, virtual: true

    belongs_to :group, Group
    belongs_to :user, User

    has_many :advantages, Advantage, on_replace: :delete
    has_many :languages, Language, on_replace: :delete
    has_many :scripts, Script, on_replace: :delete

    has_many :character_prayers, CharacterPrayer, on_replace: :delete
    has_many :character_spells, CharacterSpell, on_replace: :delete
    has_many :character_mweapons, CharacterMWeapon, on_replace: :delete
    has_many :character_fweapons, CharacterFWeapon, on_replace: :delete
    has_many :character_armors, CharacterArmor, on_replace: :delete
    has_many :character_traits, CharacterTrait, on_replace: :delete
    has_many :traits, through: [:character_traits, :trait]

    timestamps()
  end

  @required_fields ~w(user_id species_id name mu kl in ch ff ge ko kk le_bonus le_lost ae_bonus ae_lost ae_back ke_bonus ke_lost ke_back)a
  @optional_fields ~w(group_id magic_tradition_id karmal_tradition_id trait_id trait_level trait_ap trait_details spell_id prayer_id advantage_id language_id script_id)a
  def changeset(character, attrs) do
    character
    |> cast(attrs, @required_fields ++ @optional_fields ++ talent_fields() ++ combat_fields())
    |> validate_required(@required_fields ++ talent_fields() ++ combat_fields())
    |> validate_length(:name, min: 2, max: 10)
    |> validate_number(:trait_ap, not_equal_to: 0)
    |> validate_base_values()
    |> validate_combat_skills()
    |> validate_talents()
    |> validate_number(:le_bonus, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
    |> validate_number(:le_lost, greater_than_or_equal_to: 0)
    |> validate_number(:ae_bonus, greater_than_or_equal_to: 0)
    |> validate_number(:ae_lost, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
    |> validate_number(:ae_back, greater_than_or_equal_to: 0)
    |> validate_number(:ke_bonus, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
    |> validate_number(:ke_lost, greater_than_or_equal_to: 0)
    |> validate_number(:ke_back, greater_than_or_equal_to: 0)
    |> validate_number(:advantage_id, greater_than: 0, less_than_or_equal_to: Advantage.count())
    |> validate_number(:language_id, greater_than: 0, less_than_or_equal_to: Language.count())
    |> validate_number(:script_id, greater_than: 0, less_than_or_equal_to: Script.count())
    |> validate_length(:trait_details, max: 50)
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:user_id)
  end

  defp validate_base_values(changeset) do
    Enum.reduce(base_values(), changeset, fn field, changeset ->
      validate_number(changeset, field, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    end)
  end

  defp validate_combat_skills(changeset) do
    Enum.reduce(combat_fields(), changeset, fn field, changeset ->
      validate_number(changeset, field, greater_than_or_equal_to: 6, less_than_or_equal_to: 25)
    end)
  end

  defp validate_talents(changeset) do
    Enum.reduce(talent_fields(), changeset, fn field, changeset ->
      validate_number(changeset, field, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
    end)
  end

  @optional ~w(le ae ke sk zk gs aw sp ini)a
  def combat_changeset(character, attrs) do
    le = le(character)
    ae = ae(character)
    ke = ke(character)
    sk = sk(character)
    zk = zk(character)
    ini = ini(character)
    gs = gs(character)
    aw = aw(character)
    sp = sp(character)

    character
    |> cast(attrs, @optional)
    |> set_default_value(:le, le.total)
    |> set_default_value(:ae, ae.total)
    |> set_default_value(:ke, ke.total)
    |> set_default_value(:sk, sk.total)
    |> set_default_value(:zk, zk.total)
    |> set_default_value(:gs, gs.total)
    |> set_default_value(:aw, aw.total)
    |> set_default_value(:sp, sp.total)
    |> validate_number(:le, less_than_or_equal_to: le.total)
    |> validate_number(:ae, greater_than_or_equal_to: 0, less_than_or_equal_to: ae.total)
    |> validate_number(:ke, greater_than_or_equal_to: 0, less_than_or_equal_to: ae.total)
    |> validate_number(:ini, greater_than_or_equal_to: ini.total, less_than_or_equal_to: ini.total + 6)
    |> validate_number(:sp, greater_than_or_equal_to: 0, less_than_or_equal_to: sp.total)
  end

  defp set_default_value(changeset, field, default) do
    case get_field(changeset, field) do
      nil -> put_change(changeset, field, default)
      _value -> changeset
    end
  end
end
