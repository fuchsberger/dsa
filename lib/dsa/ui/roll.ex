defmodule Dsa.UI.Roll do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @traits ~w(mu kl in ch ge ff ko kk)

  embedded_schema do
    field :bonus, :integer, default: 0
    field :e1, :string, default: "mu"
    field :e2, :string, default: "mu"
    field :e3, :string, default: "mu"
    field :tw, :integer, default: 0
  end

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, [:bonus, :e1, :e2, :e3, :tw])
    |> validate_required([:bonus, :e1, :e2, :e3, :tw])
    |> validate_number(:bonus, greater_than_or_equal_to: -99, less_than_or_equal_to: 99)
    |> validate_inclusion(:e1, @traits)
    |> validate_inclusion(:e2, @traits)
    |> validate_inclusion(:e3, @traits)
    |> validate_number(:tw, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
  end
end
