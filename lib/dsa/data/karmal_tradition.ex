defmodule Dsa.Data.KarmalTradition do
  @moduledoc """
  CharacterScript module
  """

  @table :karmal_traditions

  def count, do: 6
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
      {1, "MU", "Boronkirche", 130},
      {2, "KL", "Hesindekirche", 130},
      {3, "IN", "Perainekirche", 110},
      {4, "IN", "Phexkirche", 150},
      {5, "KL", "Praioskirche", 130},
      {6, "MU", "Rondrakirche", 150}
    ])
  end
end
