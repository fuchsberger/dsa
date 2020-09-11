defmodule Dsa.Accounts.Character do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dsa.Lore.{Species, Tradition}
  alias Dsa.Accounts.{Group, User, CharacterArmor, CharacterCombatSkill, CharacterFWeapon, CharacterMWeapon, CharacterSkill, CharacterTrait, CharacterCast}

  schema "characters" do

    # Generell
    field :name, :string, default: "Held"
    field :profession, :string

    # Eigenschaften
    Enum.each(Dsa.Lists.base_values(), & field(&1, :integer, default: 8))

    # combat
    field :at, :integer, default: 5
    field :pa, :integer, default: 5
    field :w2, :boolean, default: false
    field :tp, :integer, default: 2
    field :rw, :integer, default: 1

    # stats
    field :be, :integer, default: 0
    field :rs, :integer, default: 0
    field :le_bonus, :integer, default: 0
    field :ae_bonus, :integer, default: 0
    field :ke_bonus, :integer, default: 0
    field :sk, :integer, default: 0
    field :zk, :integer, default: 0
    field :aw, :integer, default: 4

    field :ini, :integer
    field :gw, :integer, default: 8
    field :sp, :integer, default: 3
    field :skill_id, :integer, virtual: true
    field :trait_id, :integer, virtual: true
    field :trait_level, :integer, virtual: true
    field :trait_ap, :integer, virtual: true
    field :trait_details, :string, virtual: true

    belongs_to :group, Group
    belongs_to :user, User
    belongs_to :species, Species
    belongs_to :magic_tradition, Tradition
    belongs_to :karmal_tradition, Tradition

    has_many :character_casts, CharacterCast, on_replace: :delete
    has_many :character_mweapons, CharacterMWeapon, on_replace: :delete
    has_many :character_fweapons, CharacterFWeapon, on_replace: :delete
    has_many :character_armors, CharacterArmor, on_replace: :delete
    has_many :character_traits, CharacterTrait, on_replace: :delete

    has_many :character_combat_skills, CharacterCombatSkill, on_replace: :delete
    has_many :character_skills, CharacterSkill, on_replace: :delete
    has_many :combat_skills, through: [:character_combat_skills, :combat_skill]
    has_many :casts, through: [:character_casts, :cast]
    has_many :skills, through: [:character_skills, :skill]
    has_many :traits, through: [:character_traits, :trait]

    timestamps()
  end

  @required_fields ~w(species_id name at pa w2 tp rw le_bonus ae_bonus ke_bonus sk zk aw gw)a ++ Dsa.Lists.base_values()
  @optional_fields ~w(profession group_id skill_id magic_tradition_id karmal_tradition_id trait_id trait_level trait_ap trait_details)a
  def changeset(character, attrs) do
    character
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 2, max: 10)
    |> validate_length(:profession, min: 2, max: 15)
    |> validate_number(:trait_ap, not_equal_to: 0)
    |> validate_number(:le_bonus, greater_than_or_equal_to: 0)
    |> validate_number(:ae_bonus, greater_than_or_equal_to: 0)
    |> validate_number(:ke_bonus, greater_than_or_equal_to: 0)
    |> validate_length(:trait_details, max: 50)
    |> foreign_key_constraint(:species_id)
    |> foreign_key_constraint(:magic_tradition_id)
    |> foreign_key_constraint(:karmal_tradition_id)
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
