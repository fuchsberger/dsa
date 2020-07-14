defmodule Dsa.Lore.Skill do
  use Ecto.Schema
  import Ecto.Changeset

  @traits ~w(MU KL IN CH FF GE KO KK)

  schema "skills" do
    field :name, :string, required: true
    field :category, :string, required: true
    field :e1, :string, required: true
    field :e2, :string
    field :e3, :string
    field :be, :boolean

    many_to_many :characters, Dsa.Accounts.Character,
      join_through: Dsa.Accounts.CharacterSkill,
      on_replace: :delete
  end

  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:name, :category, :e1, :e2, :e3, :be])
    |> validate_required([:name, :category, :e1])
    |> validate_inclusion(:e1, @traits)
    |> validate_inclusion(:e2, @traits)
    |> validate_inclusion(:e3, @traits)
  end
end
