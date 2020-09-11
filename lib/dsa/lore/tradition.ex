defmodule Dsa.Lore.Tradition do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

  schema "traditions" do
    field :name, :string
    field :magic, :boolean
    field :le, :string
    field :ap, :integer
  end

  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:name, :magic, :le, :ap])
    |> validate_required([:name])
    |> validate_length(:name, max: 40)
    |> validate_inclusion(:le, base_value_options())
    |> validate_number(:ap, greater_than: 0)
    |> unique_constraint(:name)
  end

  def entries do
    [
      { nil, nil, "Allgemein", nil},
      # Zauberertraditionen
      { true, "KL", "Gildenmagier", 155},
      { true, "CH", "Hexe", 135},
      { true, "IN", "Elf", 125},
      # Geweihtentraditionen
      { false, "KL", "Praioskirche", 130},
      { false, "MU", "Rondrakirche", 150},
      { false, "MU", "Boronkirche", 130},
      { false, "KL", "Hesindekirche", 130},
      { false, "IN", "Phexkirche", 150},
      { false, "IN", "Perainekirche", 110}
    ]
    |> Enum.map(fn {magic, le, name, ap} -> %{name: name, le: le, magic: magic, ap: ap} end)
  end
end
