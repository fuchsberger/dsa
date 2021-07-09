defmodule Dsa.Data.MagicTradition do
  @moduledoc """
  CharacterScript module
  """

  @table :magic_traditions

  def count, do: 3
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options, do: Enum.map(list(), fn {id, _le, name, _ap} -> {name, id} end)

  def le(id), do: :ets.lookup_element(@table, id, 2)
  def name(id), do: :ets.lookup_element(@table, id, 3)
  def ap(id), do: :ets.lookup_element(@table, id, 4)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      #  {id, le, name, ap}
      {1, "KL", "Gildenmagier", 155},
      {2, "IN", "Elfen", 125},
      {3, "CH", "Hexen", 135}
    ])
  end
end
