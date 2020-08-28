defmodule Dsa.Accounts.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do

    # Generell
    field :name, :string
    field :species, :string
    field :culture, :string
    field :profession, :string
    field :monster, :boolean, virtual: true

    # Eigenschaften
    Enum.each(Dsa.Lists.base_values(), & field(&1, :integer, default: 8))

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

    belongs_to :group, Dsa.Accounts.Group
    belongs_to :user, Dsa.Accounts.User

    has_many :character_combat_skills, Dsa.Accounts.CharacterCombatSkill, on_replace: :delete
    has_many :character_skills, Dsa.Accounts.CharacterSkill, on_replace: :delete
    has_many :combat_skills, through: [:character_combat_skills, :skill]
    has_many :skills, through: [:character_skills, :skill]

    timestamps()
  end

  @fields ~w(name species culture profession at pa w2 tp rw be rs le ae ke sk zk aw ini gw sp)a
  def changeset(character, attrs) do
    required_fields = @fields ++ Dsa.Lists.base_values()

    character
    |> cast(attrs, required_fields ++ [:group_id])
    |> validate_required(required_fields)
    |> validate_length(:name, min: 2, max: 15)
    |> validate_length(:species, min: 3, max: 10)
    |> validate_length(:culture, min: 3, max: 15)
    |> validate_length(:profession, min: 2, max: 15)
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:user_id)
  end
end
