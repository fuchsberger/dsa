defmodule Dsa.DiceTableEntries.DiceTableEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dice_table_entries" do
    field :dice, :integer
    field :text, :string
    belongs_to(:dice_table, DiceTable)

    timestamps()
  end

  @doc false
  def changeset(dice_table_entry, attrs) do
    dice_table_entry
    |> cast(attrs, [:text, :dice])
    |> validate_required([:text, :dice])
    |> unique_constraint(:unique_table_dice, name: :unique_table_dice)
  end
end
