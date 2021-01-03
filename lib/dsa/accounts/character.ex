defmodule Dsa.Accounts.Character do
  use Ecto.Schema
  import Ecto.Changeset
  import Dsa.Lists
  import DsaWeb.CharacterHelpers

  alias Dsa.Data.{
    Advantage,
    Armor,
    Blessing,
    CombatTrait,
    Disadvantage,
    FateTrait,
    FWeapon,
    GeneralTrait,
    KarmalTradition,
    KarmalTrait,
    Language,
    MagicTradition,
    MagicTrait,
    MWeapon,
    Prayer,
    Script,
    Species,
    Spell,
    SpellTrick,
    StaffSpell
  }

  alias Dsa.Accounts.User

  schema "characters" do

    # base values
    Enum.each(base_values(), & field(&1, :integer, default: 8))

    # general
    field :name, :string, default: "Held"
    # field :title, :string
    # field :height, :float
    # field :weight, :integer
    # field :origin, :string
    # field :birthday, :string
    # field :age, :integer
    # field :culture, :string
    field :profession, :string

    # # talents
    # Enum.each(combat_fields(), & field(&1, :integer, default: 6))
    # Enum.each(talent_fields(), & field(&1, :integer, default: 0))

    # # combat
    # field :at, :integer, default: 5
    # field :pa, :integer, default: 5
    # field :tp_dice, :integer, default: 1
    # field :tp_bonus, :integer, default: 2
    # field :be, :integer, default: 0
    # field :rs, :integer, default: 0

    # # stats
    # field :le_bonus, :integer, default: 0
    # field :le_lost, :integer, default: 0
    # field :ae_bonus, :integer, default: 0
    # field :ae_lost, :integer, default: 0
    # field :ae_back, :integer, default: 0
    # field :ke_bonus, :integer, default: 0
    # field :ke_lost, :integer, default: 0
    # field :ke_back, :integer, default: 0

    # # overwrites
    # field :le, :integer
    # field :ke, :integer
    # field :ae, :integer
    # field :sk, :integer
    # field :zk, :integer
    # field :ini, :integer
    # field :gs, :integer
    # field :aw, :integer
    # field :sp, :integer

    # # ets relations
    # field :species_id, :integer, default: 1
    # field :magic_tradition_id, :integer
    # field :karmal_tradition_id, :integer

    # # virtual fields
    # field :add_armor_id, :integer, virtual: true
    # field :blessing_id, :integer, virtual: true
    # field :combat_trait_id, :integer, virtual: true
    # field :fate_trait_id, :integer, virtual: true
    # field :fweapon_id, :integer, virtual: true
    # field :general_trait_id, :integer, virtual: true
    # field :karmal_trait_id, :integer, virtual: true
    # field :magic_trait_id, :integer, virtual: true
    # field :mweapon_id, :integer, virtual: true
    # field :prayer_id, :integer, virtual: true
    # field :spell_id, :integer, virtual: true
    # field :spell_trick_id, :integer, virtual: true
    # field :staff_spell_id, :integer, virtual: true

    belongs_to :user, User
    # belongs_to :armor, Armor

    # has_many :advantages, Advantage, on_replace: :delete
    # has_many :armors, Armor, on_replace: :delete
    # has_many :blessings, Blessing, on_replace: :delete
    # has_many :combat_traits, CombatTrait, on_replace: :delete
    # has_many :disadvantages, Disadvantage, on_replace: :delete
    # has_many :fweapons, FWeapon, on_replace: :delete
    # has_many :general_traits, GeneralTrait, on_replace: :delete
    # has_many :fate_traits, FateTrait, on_replace: :delete
    # has_many :karmal_traits, KarmalTrait, on_replace: :delete
    # has_many :languages, Language, on_replace: :delete
    # has_many :magic_traits, MagicTrait, on_replace: :delete
    # has_many :mweapons, MWeapon, on_replace: :delete
    # has_many :scripts, Script, on_replace: :delete
    # has_many :prayers, Prayer, on_replace: :delete
    # has_many :spells, Spell, on_replace: :delete
    # has_many :spell_tricks, SpellTrick, on_replace: :delete
    # has_many :staff_spells, StaffSpell, on_replace: :delete

    timestamps()
  end

  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :profession, :mu, :kl, :in, :ch, :ge, :ff, :ko, :kk])
    |> validate_required([:name, :profession, :mu, :kl, :in, :ch, :ge, :ff, :ko, :kk])
    |> validate_length(:name, min: 2, max: 25)
    |> validate_length(:profession, min: 2, max: 80)
    |> validate_number(:mu, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:kl, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:in, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:ch, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:ge, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:ff, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:ko, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:kk, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
  end

  # @required_fields ~w(le_bonus le_lost ae_bonus ae_lost ae_back ke_bonus ke_lost ke_back)a
  # @optional_fields ~w(add_armor_id armor_id blessing_id combat_trait_id fate_trait_id fweapon_id general_trait_id karmal_tradition_id karmal_trait_id magic_tradition_id magic_trait_id mweapon_id prayer_id spell_id spell_trick_id staff_spell_id)a
  # def changeset(character, attrs) do
  #   character
  #   |> cast(attrs, @required_fields ++ @optional_fields ++ talent_fields() ++ combat_fields())
  #   |> validate_required(@required_fields ++ talent_fields() ++ combat_fields())
  #   |> validate_length(:name, min: 2, max: 10)
  #   |> validate_combat_skills()
  #   |> validate_talents()
  #   |> validate_number(:le_bonus, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
  #   |> validate_number(:le_lost, greater_than_or_equal_to: 0)
  #   |> validate_number(:ae_bonus, greater_than_or_equal_to: 0)
  #   |> validate_number(:ae_lost, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
  #   |> validate_number(:ae_back, greater_than_or_equal_to: 0)
  #   |> validate_number(:ke_bonus, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
  #   |> validate_number(:ke_lost, greater_than_or_equal_to: 0)
  #   |> validate_number(:ke_back, greater_than_or_equal_to: 0)
  #   |> validate_number(:add_armor_id, greater_than: 0, less_than_or_equal_to: Armor.count())
  #   |> validate_number(:blessing_id, greater_than: 0, less_than_or_equal_to: Blessing.count())
  #   |> validate_number(:combat_trait_id, greater_than: 0, less_than_or_equal_to: CombatTrait.count())
  #   |> validate_number(:fate_trait_id, greater_than: 0, less_than_or_equal_to: FateTrait.count())
  #   |> validate_number(:fweapon_id, greater_than: 0, less_than_or_equal_to: FWeapon.count())
  #   |> validate_number(:general_trait_id, greater_than: 0, less_than_or_equal_to: GeneralTrait.count())
  #   |> validate_number(:karmal_tradition_id, greater_than: 0, less_than_or_equal_to: KarmalTradition.count())
  #   |> validate_number(:karmal_trait_id, greater_than: 0, less_than_or_equal_to: KarmalTrait.count())
  #   |> validate_number(:magic_tradition_id, greater_than: 0, less_than_or_equal_to: MagicTradition.count())
  #   |> validate_number(:magic_trait_id, greater_than: 0, less_than_or_equal_to: MagicTrait.count())
  #   |> validate_number(:mweapon_id, greater_than: 0, less_than_or_equal_to: MWeapon.count())
  #   |> validate_number(:prayer_id, greater_than: 0, less_than_or_equal_to: Prayer.count())
  #   |> validate_number(:spell_id, greater_than: 0, less_than_or_equal_to: Spell.count())
  #   |> validate_number(:spell_trick_id, greater_than: 0, less_than_or_equal_to: SpellTrick.count())
  #   |> validate_number(:staff_spell_id, greater_than: 0, less_than_or_equal_to: StaffSpell.count())
  #   |> foreign_key_constraint(:armor_id)
  # end

  # def changeset(character, attrs, :base_values) do
  #   character
  #   |> cast(attrs, base_values())
  #   |> validate_required(base_values())
  #   |> validate_base_values()
  # end

  # def changeset(character, attrs, :general) do
  #   character
  #   |> cast(attrs, [:name, :title, :height, :weight, :origin, :birthday, :age, :culture, :profession, :species_id])
  #   |> validate_required([:name, :species_id])
  #   |> validate_length(:name, min: 2, max: 15)
  #   |> validate_length(:title, min: 3, max: 20)
  #   |> validate_length(:origin, min: 3, max: 20)
  #   |> validate_length(:birthday, min: 3, max: 20)
  #   |> validate_length(:culture, min: 3, max: 20)
  #   |> validate_length(:profession, min: 3, max: 20)
  #   |> validate_number(:age, greater_than: 10)
  #   |> validate_number(:height, greater_than: 1.0, less_than: 2.5)
  #   |> validate_number(:weight, greater_than: 30)
  #   |> validate_number(:species_id, greater_than: 0, less_than_or_equal_to: Species.count())
  # end

  # defp validate_base_values(changeset) do
  #   Enum.reduce(base_values(), changeset, fn field, changeset ->
  #     validate_number(changeset, field, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
  #   end)
  # end

  # defp validate_combat_skills(changeset) do
  #   Enum.reduce(combat_fields(), changeset, fn field, changeset ->
  #     validate_number(changeset, field, greater_than_or_equal_to: 6, less_than_or_equal_to: 25)
  #   end)
  # end

  # defp validate_talents(changeset) do
  #   Enum.reduce(talent_fields(), changeset, fn field, changeset ->
  #     validate_number(changeset, field, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
  #   end)
  # end

  # @optional ~w(le ae ke sk zk gs aw sp ini)a
  # def combat_changeset(character, attrs) do
  #   le = le(character)
  #   ae = ae(character)
  #   ke = ke(character)
  #   sk = sk(character)
  #   zk = zk(character)
  #   ini = ini(character)
  #   gs = gs(character)
  #   aw = aw(character)
  #   sp = sp(character)

  #   character
  #   |> cast(attrs, @optional)
  #   |> set_default_value(:le, le.total)
  #   |> set_default_value(:ae, ae.total)
  #   |> set_default_value(:ke, ke.total)
  #   |> set_default_value(:sk, sk.total)
  #   |> set_default_value(:zk, zk.total)
  #   |> set_default_value(:gs, gs.total)
  #   |> set_default_value(:aw, aw.total)
  #   |> set_default_value(:sp, sp.total)
  #   |> validate_number(:le, less_than_or_equal_to: le.total)
  #   |> validate_number(:ae, greater_than_or_equal_to: 0, less_than_or_equal_to: ae.total)
  #   |> validate_number(:ke, greater_than_or_equal_to: 0, less_than_or_equal_to: ae.total)
  #   |> validate_number(:ini, greater_than_or_equal_to: ini.total, less_than_or_equal_to: ini.total + 6)
  #   |> validate_number(:sp, greater_than_or_equal_to: 0, less_than_or_equal_to: sp.total)
  # end

  # defp set_default_value(changeset, field, default) do
  #   case get_field(changeset, field) do
  #     nil -> put_change(changeset, field, default)
  #     _value -> changeset
  #   end
  # end
end
