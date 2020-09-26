defmodule Dsa.Data.Species do
  @moduledoc """
  CharacterSpecies module
  """
  @table :species

  def count, do: 4
  def list, do: :ets.tab2list(@table)

  def options do
    Enum.map(list(), fn {id, name, _le, _sk, _zk, _gs, ap} -> {"#{name} (#{ap})", id} end)
  end

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def le(id), do: :ets.lookup_element(@table, id, 3)
  def sk(id), do: :ets.lookup_element(@table, id, 4)
  def zk(id), do: :ets.lookup_element(@table, id, 5)
  def gs(id), do: :ets.lookup_element(@table, id, 6)
  def ap(id), do: :ets.lookup_element(@table, id, 7)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, le, sk, zk, gs, ap}
      {1, "Mensch",  5, -5, -5, 8, 0},
      {2, "Elf",     2, -4, -6, 8, 18},
      {3, "Halbelf", 5, -4, -6, 8, 0},
      {4, "Zwerg",   8, -4, -4, 6, 61}
    ])
  end
end
