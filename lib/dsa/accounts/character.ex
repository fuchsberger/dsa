defmodule Dsa.Accounts.Character do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dsa.Accounts.{Group, User, CharacterArmor, CharacterCombatSkill, CharacterFWeapon, CharacterMWeapon, CharacterSkill, CharacterTrait, CharacterSpell, CharacterPrayer}

  schema "characters" do

    # general
    field :name, :string, default: "Held"
    field :profession, :string

    # base traits
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

    # Virtual Fields for adding traits, spells and liturgies
    field :trait_id, :integer, virtual: true
    field :trait_level, :integer, virtual: true
    field :trait_ap, :integer, virtual: true
    field :trait_details, :string, virtual: true
    field :spell_id, :integer, virtual: true
    field :prayer_id, :integer, virtual: true

    # ets relations
    field :species_id, :integer, default: 1
    field :magic_tradition_id, :integer
    field :karmal_tradition_id, :integer

    belongs_to :group, Group
    belongs_to :user, User

    has_many :character_prayers, CharacterPrayer, on_replace: :delete
    has_many :character_spells, CharacterSpell, on_replace: :delete
    has_many :character_mweapons, CharacterMWeapon, on_replace: :delete
    has_many :character_fweapons, CharacterFWeapon, on_replace: :delete
    has_many :character_armors, CharacterArmor, on_replace: :delete
    has_many :character_traits, CharacterTrait, on_replace: :delete

    has_many :character_combat_skills, CharacterCombatSkill, on_replace: :delete
    has_many :character_skills, CharacterSkill, on_replace: :delete
    has_many :combat_skills, through: [:character_combat_skills, :combat_skill]
    has_many :skills, through: [:character_skills, :skill]
    has_many :traits, through: [:character_traits, :trait]

    timestamps()
  end

  @required_fields ~w(species_id name mu kl in ch ff ge ko kk le_bonus le_lost ae_bonus ae_lost ae_back ke_bonus ke_lost ke_back)a
  @optional_fields ~w(profession group_id magic_tradition_id karmal_tradition_id trait_id trait_level trait_ap trait_details spell_id prayer_id)a
  def changeset(character, attrs) do
    character
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 2, max: 10)
    |> validate_length(:profession, min: 2, max: 15)
    |> validate_number(:trait_ap, not_equal_to: 0)
    |> validate_number(:kl, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:mu, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:in, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:ch, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:ff, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:ge, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:ko, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:kk, greater_than_or_equal_to: 8, less_than_or_equal_to: 25)
    |> validate_number(:le_bonus, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
    |> validate_number(:le_lost, greater_than_or_equal_to: 0)
    |> validate_number(:ae_bonus, greater_than_or_equal_to: 0)
    |> validate_number(:ae_lost, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
    |> validate_number(:ae_back, greater_than_or_equal_to: 0)
    |> validate_number(:ke_bonus, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
    |> validate_number(:ke_lost, greater_than_or_equal_to: 0)
    |> validate_number(:ke_back, greater_than_or_equal_to: 0)
    |> validate_length(:trait_details, max: 50)
    |> foreign_key_constraint(:group_id)
  end

  @cfields ~w()a
  def combat_changeset(character, attrs) do
    character
    |> cast(attrs, [:ini | @cfields])
    |> validate_required(@cfields)
    |> validate_number(:ini, greater_than: 0)
  end
end
