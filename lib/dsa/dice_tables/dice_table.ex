defmodule Dsa.DiceTables.DiceTable do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dice_tables" do
    field :table_name, :string
    has_many :entries, DiceTableEntry

    timestamps()
  end

  @doc false
  def changeset(dice_table, attrs) do
    dice_table
    |> cast(attrs, [:table_name])
    |> validate_required([:table_name])
  end
end
