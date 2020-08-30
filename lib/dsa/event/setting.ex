defmodule Dsa.Event.Setting do

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :type, :string, default: "Eigenschaft"
    field :dice_count, :integer, default: 3
    field :dice_type, :integer, default: 20
    field :dice_hidden, :boolean, default: false
    field :modifier, :integer, default: 0
    field :hidden, :boolean, default: false
  end

  @fields ~w(type dice_count dice_type modifier hidden)a

  def changeset(settings, attrs) do
    settings
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_number(:modifier, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> validate_inclusion(:type, ["Eigenschaft", "Körper", "Natur", "Gesellschaft", "Wissen", "Handwerk"])
  end
end
