defmodule Dsa.Characters.Character do
  use Ecto.Schema

  import Ecto.Changeset

  schema "characters" do
    field :name, :string
    field :profession, :string
    field :visible, :boolean, default: false

    field :mu, :integer, default: 8
    field :kl, :integer, default: 8
    field :in, :integer, default: 8
    field :ch, :integer, default: 8
    field :ff, :integer, default: 8
    field :ge, :integer, default: 8
    field :ko, :integer, default: 8
    field :kk, :integer, default: 8

    field :le_max, :integer, default: 0
    field :ae_max, :integer, default: 0
    field :ke_max, :integer, default: 0
    field :le, :integer, default: 0
    field :ke, :integer, default: 0
    field :ae, :integer, default: 0
    field :sk, :integer, default: 0
    field :zk, :integer, default: 0
    field :sp, :integer, default: 3

    field :ini_basis, :integer, default: 0
    field :ini, :integer

    belongs_to :user, Dsa.Accounts.User
    belongs_to :active_combat_set, Dsa.Characters.CombatSet, on_replace: :nilify

    has_many :character_skills, Dsa.Characters.CharacterSkill, on_replace: :delete
    has_many :character_spells, Dsa.Characters.CharacterSpell, on_replace: :delete
    has_many :character_blessings, Dsa.Characters.CharacterBlessing, on_replace: :delete
    has_many :combat_sets, Dsa.Characters.CombatSet, on_replace: :delete

    timestamps()
  end

  @required ~w(name le_max ae_max ke_max mu kl in ch ff ge ko kk ini_basis)a
  @optional ~w(profession visible le ae ke sk zk sp ini active_combat_set_id)a

  def changeset(character, attrs) do
    character
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:name, min: 2, max: 25)
    |> validate_length(:profession, min: 2, max: 80)
    |> validate_number(:mu, greater_than_or_equal_to: 0)
    |> validate_number(:kl, greater_than_or_equal_to: 0)
    |> validate_number(:in, greater_than_or_equal_to: 0)
    |> validate_number(:ch, greater_than_or_equal_to: 0)
    |> validate_number(:ff, greater_than_or_equal_to: 0)
    |> validate_number(:ge, greater_than_or_equal_to: 0)
    |> validate_number(:ko, greater_than_or_equal_to: 0)
    |> validate_number(:kk, greater_than_or_equal_to: 0)
    |> validate_number(:le_max, greater_than_or_equal_to: 0, less_than: 1000)
    |> validate_number(:ae_max, greater_than_or_equal_to: 0, less_than: 1000)
    |> validate_number(:ke_max, greater_than_or_equal_to: 0, less_than: 1000)
    |> validate_number(:le, greater_than_or_equal_to: -50, less_than: 1000)
    |> validate_number(:ae, greater_than_or_equal_to: -50, less_than: 1000)
    |> validate_number(:ke, greater_than_or_equal_to: -50, less_than: 1000)
    |> validate_number(:sk, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> validate_number(:zk, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> validate_number(:sp, greater_than_or_equal_to: 0, less_than_or_equal_to: 6)
    |> validate_number(:ini_basis, greater_than_or_equal_to: 0, less_than_or_equal_to: 30)
    |> foreign_key_constraint(:active_combat_set_id)
  end
end
