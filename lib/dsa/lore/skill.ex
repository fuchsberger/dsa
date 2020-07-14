defmodule Dsa.Lore.Skill do
  use Ecto.Schema
  import Ecto.Changeset

  @sf ~w(A B C D E)
  @base_values ~w(MU KL IN CH FF GE KO KK)
  @categories ~w(Körper Gesellschaft Natur Wissen Handwerk Zauber Liturgie)

  schema "skills" do
    field :name, :string
    field :category, :string
    field :e1, :string
    field :e2, :string
    field :e3, :string
    field :be, :boolean
    field :sf, :string

    many_to_many :characters, Dsa.Accounts.Character,
      join_through: Dsa.Accounts.CharacterSkill,
      on_replace: :delete
  end

  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:name, :category, :e1, :e2, :e3, :be, :sf])
    |> validate_required([:name, :category, :e1, :e2, :e3, :sf])
    |> validate_length(:name, max: 40)
    |> validate_inclusion(:category, @categories)
    |> validate_inclusion(:e1, @base_values)
    |> validate_inclusion(:e2, @base_values)
    |> validate_inclusion(:e3, @base_values)
    |> validate_inclusion(:sf, @sf)
  end

  def base_options, do: Enum.map(@base_values, & {&1, &1})
  def category_options, do: Enum.map(@categories, & {&1, &1})
  def sf_options, do: Enum.map(@sf, & {&1, &1})
end
