defmodule Dsa.Data.CombatSkill do
  @moduledoc """
  CharacterScript module
  """

  @table :combat_skills

  def count, do: 21
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options do
    Enum.map(list(), fn {id, _sf, _ranged, _parade, _ge, _kk, name, _stability} -> {name, id} end)
  end

  def sf(id), do: :ets.lookup_element(@table, id, 2)
  def ranged(id), do: :ets.lookup_element(@table, id, 3)
  def parade(id), do: :ets.lookup_element(@table, id, 4)
  def ge(id), do: :ets.lookup_element(@table, id, 5)
  def kk(id), do: :ets.lookup_element(@table, id, 6)
  def name(id), do: :ets.lookup_element(@table, id, 7)
  def stability(id), do: :ets.lookup_element(@table, id, 8)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, sf, ranged, parade, ge, kk, name, stability}
      {1, "B", false, true, true, false, "Dolche", 14 },
      {2, "C", false, true, true, false, "Fächer", 13 },
      {3, "C", false, true, true, false, "Fechtwaffen", 8 },
      {4, "C", false, true, false, true, "Hiebwaffen", 12 },
      {5, "C", false, false, false, true, "Kettenwaffen", 10 },
      {6, "B", false, true, false, true, "Lanzen", 6 },
      {7, "B", false, false, false, false, "Peitschen", 4 },
      {8, "B", false, true, true, true, "Raufen", 12 },
      {9, "C", false, true, false, true, "Schilde", 10 },
      {10, "C", false, true, true, true, "Schwerter", 13 },
      {11, "C", false, false, false, true, "Spießwaffen", 12 },
      {12, "C", false, true, true, true, "Stangenwaffen", 12 },
      {13, "C", false, true, false, true, "Zweihandhiebwaffen", 11 },
      {14, "C", false, true, false, true, "Zweihandschwerter", 12 },
      # Ranged combat
      {15, "B", true, false, false, false, "Armbrüste", 6 },
      {16, "B", true, false, false, false, "Blasrohre", 10 },
      {17, "C", true, false, false, false, "Bögen", 4 },
      {18, "C", true, false, false, false, "Diskusse", 12 },
      {19, "B", true, false, false, false, "Feuerspeien", 20 },
      {20, "B", true, false, false, false, "Schleudern", 4 },
      {21, "B", true, false, false, false, "Wurfwaffen", 10 }
    ])
  end
end
