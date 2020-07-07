defmodule Dsa.Game.Skill do
  use Ecto.Schema
  import Ecto.Changeset

  @categories ~w(Körper Gesellschaft Natur Wissen Handwerk Zauber)
  @traits ~w(MU KL IN CH FF GE KO KK)

  schema "skills" do
    field :name, :string, required: true
    field :category, :string, required: true
    field :e1, :string, required: true
    field :e2, :string, required: true
    field :e3, :string, required: true
    field :be, :boolean

    many_to_many :characters, Dsa.Game.Character, join_through: Dsa.Game.CharacterSkill
  end

  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:name, :category, :e1, :e2, :e3, :be])
    |> validate_required([:name, :category, :e1, :e2, :e3])
    |> validate_inclusion(:category, @categories)
    |> validate_inclusion(:e1, @traits)
    |> validate_inclusion(:e2, @traits)
    |> validate_inclusion(:e3, @traits)
  end
end

defmodule Dsa.Game.CharacterSkill do
  use Ecto.Schema

  schema "character_skills" do
    field :level, :integer, required: true, default: 0

    belongs_to :character, Dsa.Game.Character
    belongs_to :skill, Dsa.Game.Skill
  end
end
