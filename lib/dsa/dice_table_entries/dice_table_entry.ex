defmodule Dsa.DiceTableEntries.DiceTableEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dice_table_entries" do
    field :result, :string
    field :description, :string
    field :dice_table_id, :integer

    timestamps()
  end

  @doc false
  def changeset(dice_table_entry, attrs) do
    dice_table_entry
    |> cast(attrs, [:result, :description, :dice_table_id])
    |> validate_required([:result, :dice_table_id])
  end

end
