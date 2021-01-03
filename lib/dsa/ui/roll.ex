defmodule Dsa.UI.Roll do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :modifier, :integer, default: 0
    field :e1, :integer, default: 1
    field :e2, :integer, default: 1
    field :e3, :integer, default: 2
    field :tw, :integer, default: 0
  end

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, [:modifier, :e1, :e2, :e3, :tw])
    |> validate_required([:modifier, :e1, :e2, :e3, :tw])
    |> validate_number(:e1, greater_than_or_equal_to: 0, less_than_or_equal_to: 7)
    |> validate_number(:e2, greater_than_or_equal_to: 0, less_than_or_equal_to: 7)
    |> validate_number(:e3, greater_than_or_equal_to: 0, less_than_or_equal_to: 7)
    |> validate_number(:tw, greater_than_or_equal_to: 0, less_than_or_equal_to: 25)
  end
end
