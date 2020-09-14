defmodule Dsa.Accounts.Character do
  use Ecto.Schema
  import Ecto.Changeset
  import Dsa.Lists

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
    field :ini, :integer, default: 0

    # ets relations
    field :species_id, :integer, default: 1
    field :magic_tradition_id, :integer
    field :karmal_tradition_id, :integer

    # Virtual Fields for adding traits, spells and liturgies
    field :trait_id, :integer, virtual: true
    field :trait_level, :integer, virtual: true
    field :trait_ap, :integer, virtual: true
    field :trait_details, :string, virtual: true
    field :spell_id, :integer, virtual: true
    field :prayer_id, :integer, virtual: true

    belongs_to :group, Group
    belongs_to :user, User

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
  @optional_fields ~w(group_id magic_tradition_id karmal_tradition_id trait_id trait_level trait_ap trait_details spell_id prayer_id)a
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

  @required ~w()a
  @optional ~w(ini)a
  def combat_changeset(character, attrs) do
    character
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_number(:ini, greater_than_or_equal_to: 0)
  end
end
