defmodule Dsa.UI.Roll do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :modifier, :integer, default: 0
  end

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, [:modifier])
    |> validate_required([:modifier])
  end
end
