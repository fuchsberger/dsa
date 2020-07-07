defmodule Dsa.Game.Character do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(name ap species culture profession mu kl in ch ff ge ko kk at pa w2 tp rw be rs le ae ke sk zk aw ini gw sp)a

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

    belongs_to :user, Dsa.Accounts.User

    has_many :character_skills, Dsa.Game.CharacterSkill
    has_many :skills, through: [:character_skills, :skill]

    timestamps()
  end

  def changeset(character, attrs) do
    character
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:user_id)
  end

  def changeset_update_skills(character, skills) do
    character
    |> cast(%{}, @fields)
    |> put_assoc(:skills, skills)
  end
end
