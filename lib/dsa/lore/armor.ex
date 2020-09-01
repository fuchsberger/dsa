defmodule Dsa.Lore.Armor do
  use Ecto.Schema

  import Ecto.Changeset

  schema "armors" do
    field :name, :string
    field :rs, :integer
    field :be, :integer
    field :penalties, :boolean, default: false
  end

  @fields ~w(id name rs be penalties)a
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:id | @fields])
    |> validate_required(@fields)
    |> validate_length(:name, max: 25)
    |> validate_number(:rs, greater_than_or_equal_to: 0, less_than: 12)
    |> validate_number(:be, greater_than_or_equal_to: 0, less_than: 6)
  end
end
