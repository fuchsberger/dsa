defmodule Dsa.UI.CombatSetting do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :at, :integer, default: 5
    field :pa, :integer, default: 5
    field :aw, :integer, default: 5
    field :tp_dice, :integer, default: 1
    field :tp_bonus, :integer, default: 0
  end

  @fields ~w(at pa aw tp_dice tp_bonus)a
  def changeset(settings, attrs) do
    settings
    |> cast(attrs, @fields)
    |> validate_number(:at, greater_than: 0, less_than: 30)
    |> validate_number(:pa, greater_than: 0, less_than: 30)
    |> validate_number(:aw, greater_than: 0, less_than: 20)
    |> validate_number(:tp_dice, greater_than_or_equal_to: 0, less_than: 4)
    |> validate_number(:tp_bonus, greater_than_or_equal_to: 0, less_than: 20)
  end
end
