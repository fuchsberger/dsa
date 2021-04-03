defmodule Dsa.DiceTableEntries.DiceTableEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dice_table_entries" do
    field :text, :string
    field :dice_table_id, :integer

    timestamps()
  end

  @doc false
  def changeset(dice_table_entry, attrs) do
    dice_table_entry
    |> cast(attrs, [:text, :dice_table_id])
    |> validate_required([:text, :dice_table_id])
    |> unique_constraint(:dice_table_unique, name: :dice_table_unique)
  end
end
