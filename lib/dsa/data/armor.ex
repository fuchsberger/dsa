defmodule Dsa.Data.Armor do
  @moduledoc """
  Armor module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset

  @table :armors

  schema "armors" do
    field :dmg, :integer, default: 0
    field :armor_id, :integer
    belongs_to :character, Dsa.Accounts.Character
  end

  @fields ~w(armor_id character_id dmg)a
  def changeset(armor, params) do
    IO.inspect params
    armor
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:dmg, greater_than_or_equal_to: 0, less_than_or_equal_to: 4)
    |> validate_number(:armor_id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
  end

  def count, do: 10
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(c) do
    character_ids = Enum.map(c.armors, & &1.id)
    1..count()
    |> Enum.reject(& Enum.member?(character_ids, &1))
    |> Enum.map(& {name(&1), &1})
  end

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def rs(id), do: :ets.lookup_element(@table, id, 3)
  def be(id), do: :ets.lookup_element(@table, id, 4)
  def stability(id), do: :ets.lookup_element(@table, id, 5)
  def penalties(id), do: :ets.lookup_element(@table, id, 6)

  def tooltip(_id) do
    ~E"""
    <p class="small mb-1">TODO</p>
    """
  end

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, rs, be, stability, penalties}
      {1, "Normale Kleidung", 0, 0, 4, false},
      {2, "Winter Kleidung", 1, 0, 5, true },
      {3, "Iryanrüstung", 3, 1, 8, true },
      {4, "Kettenhemd", 4, 2, 13, false },
      {5, "Krötenhaut", 3, 1, 8, true },
      {6, "Lederharnisch", 3, 1, 8, true },
      {7, "Leichte Platte", 6, 3, 11, false },
      {8, "Schuppenpanzer", 5, 2, 12, true },
      {9, "Spiegelpanzer", 4, 2, 13, false },
      {10, "Tuchrüstung", 2, 1, 6, false }
    ])
  end
end
