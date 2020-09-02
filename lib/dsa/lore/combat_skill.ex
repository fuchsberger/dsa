defmodule Dsa.Lore.CombatSkill do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

  schema "combat_skills" do
    field :name, :string
    field :ranged, :boolean
    field :parade, :boolean
    field :e1, :string
    field :e2, :string
    field :sf, :string

    has_many :weapons, Dsa.Lore.Weapon

    many_to_many :special_skills, Dsa.Lore.SpecialSkill,
      join_through: "combat_special_skills",
      on_replace: :delete

    many_to_many :characters, Dsa.Accounts.Character,
      join_through: Dsa.Accounts.CharacterCombatSkill,
      on_replace: :delete
  end

  @fields ~w(id name ranged parade e1 e2 sf)a
  @reqired ~w(id name ranged parade e1 sf)a
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @fields)
    |> validate_required(@reqired)
    |> validate_inclusion(:e1, base_value_options())
    |> validate_inclusion(:e2, base_value_options())
    |> validate_inclusion(:sf, sf_values())
  end
end
