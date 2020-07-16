defmodule Dsa.Lore.Skill do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

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
    |> validate_length(:name, max: 30)
    |> validate_inclusion(:category, talent_categories())
    |> validate_inclusion(:e1, base_value_options())
    |> validate_inclusion(:e2, base_value_options())
    |> validate_inclusion(:e3, base_value_options())
    |> validate_inclusion(:sf, sf_values())
  end
end
