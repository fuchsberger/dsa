defmodule Dsa.Game.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do

    # Generell
    field :name, :string
    field :ap, :integer
    field :species, :string
    field :culture, :string
    field :profession, :string
    field :title, :string
    field :eyecolor, :string
    field :height, :integer
    field :weight, :integer
    field :birthplace, :string
    field :haircolor, :string
    field :created, :boolean, default: false

    # Eigenschaften
    field :mu, :integer, default: 8
    field :kl, :integer, default: 8
    field :in, :integer, default: 8
    field :ch, :integer, default: 8
    field :ff, :integer, default: 8
    field :ge, :integer, default: 8
    field :ko, :integer, default: 8
    field :kk, :integer, default: 8

    belongs_to :user, Dsa.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :ap, :mu, :kl, :in, :ch, :ff, :ge, :ko, :kk])
    |> validate_required([:name, :ap, :mu, :kl, :in, :ch, :ff, :ge, :ko, :kk])
    |> validate_number(:mu, greater_than_or_equal_to: 8)
    |> validate_number(:kl, greater_than_or_equal_to: 8)
    |> validate_number(:in, greater_than_or_equal_to: 8)
    |> validate_number(:ch, greater_than_or_equal_to: 8)
    |> validate_number(:ff, greater_than_or_equal_to: 8)
    |> validate_number(:ge, greater_than_or_equal_to: 8)
    |> validate_number(:ko, greater_than_or_equal_to: 8)
    |> validate_number(:kk, greater_than_or_equal_to: 8)
  end
end
