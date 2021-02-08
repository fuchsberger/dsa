defmodule Dsa.Data.Skill do
  @moduledoc """
  CharacterSpecies module
  """
  @table :skills

  def count, do: 58
  def list, do: :ets.tab2list(@table)

  def options, do:  Enum.map(list(), fn {id, _sf, _category, _probe, name, _be} -> {name, id} end)

  def sf(id), do: :ets.lookup_element(@table, id, 2)
  def category(id), do: :ets.lookup_element(@table, id, 3)
  def probe(id), do: :ets.lookup_element(@table, id, 4)
  def name(id), do: :ets.lookup_element(@table, id, 5)
  def be(id), do: :ets.lookup_element(@table, id, 6)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, sf, category, probe, name, be}
      # Körper
      {1, "B", 1, "MU/IN/GE", "Fliegen", true },
      {2, "A", 1, "MU/CH/FF", "Gaukeleien", true },
      {3, "B", 1, "MU/GE/KK", "Klettern", true },
      {4, "D", 1, "GE/GE/KO", "Körperbeherrschung", true },
      {5, "B", 1, "KO/KK/KK", "Kraftakt", true },
      {6, "B", 1, "CH/GE/KK", "Reiten", true },
      {7, "B", 1, "GE/KO/KK", "Schwimmen", true },
      {8, "D", 1, "MU/MU/KO", "Selbstbeherrschung", false },
      {9, "A", 1, "KL/CH/KO", "Singen", nil },
      {10, "D", 1, "KL/IN/IN", "Sinnesschärfe", nil },
      {11, "A", 1, "KL/CH/GE", "Tanzen", true },
      {12, "B", 1, "MU/FF/GE", "Taschendiebstahl", true },
      {13, "C", 1, "MU/IN/GE", "Verbergen", true },
      {14, "A", 1, "KL/KO/KK", "Zechen", false },
      # Gesellschaft
      {15, "B", 2, "MU/KL/CH", "Bekehren / Überzeugen", false },
      {16, "B", 2, "MU/CH/CH", "Betören", nil },
      {17, "B", 2, "MU/IN/CH", "Einschüchtern", false },
      {18, "B", 2, "KL/IN/CH", "Etikette", nil },
      {19, "C", 2, "KL/IN/CH", "Gassenwissen", nil },
      {20, "C", 2, "KL/IN/CH", "Menschenkenntnis", false },
      {21, "C", 2, "MU/IN/CH", "Überreden", false },
      {22, "B", 2, "IN/CH/GE", "Verkleiden", nil },
      {23, "D", 2, "MU/IN/CH", "Willenskraft", false },
      # Talents: Nature
      {24, "C", 3, "MU/IN/CH", "Fährtensuchen", true },
      {25, "A", 3, "KL/FF/KK", "Fesseln", nil },
      {26, "A", 3, "FF/GE/KO", "Fischen & Angeln", nil },
      {27, "B", 3, "KL/IN/IN", "Orientierung", false },
      {28, "C", 3, "KL/FF/KO", "Pflanzenkunde", nil },
      {29, "C", 3, "MU/MU/CH", "Tierkunde", true },
      {30, "C", 3, "MU/GE/KO", "Wildnisleben", true },
      # Talents: Knowledge
      {31, "A", 4, "KL/KL/IN", "Brett- & Glücksspiel", false },
      {32, "B", 4, "KL/KL/IN", "Geographie", false },
      {33, "B", 4, "KL/KL/IN", "Geschichtswissen", false },
      {34, "B", 4, "KL/KL/IN", "Götter & Kulte", false },
      {35, "B", 4, "MU/KL/IN", "Kriegskunst", false },
      {36, "C", 4, "KL/KL/IN", "Magiekunde", false },
      {37, "B", 4, "KL/KL/FF", "Mechanik", false },
      {38, "A", 4, "KL/KL/IN", "Rechnen", false },
      {39, "A", 4, "KL/KL/IN", "Rechtskunde", false },
      {40, "B", 4, "KL/KL/IN", "Sagen & Legenden", false },
      {41, "B", 4, "KL/KL/IN", "Sphärenkunde", false },
      {42, "A", 4, "KL/KL/IN", "Sternkunde", false },
      # Talents: Crafting
      {43, "C", 5, "MU/KL/FF", "Alchimie", true },
      {44, "B", 5, "FF/GE/KK", "Boote & Schiffe", true },
      {45, "A", 5, "CH/FF/KO", "Fahrzeuge", true },
      {46, "B", 5, "KL/IN/CH", "Handel", false },
      {47, "B", 5, "MU/KL/IN", "Heilkunde Gift", true },
      {48, "B", 5, "MU/IN/KO", "Heilkunde Krankheiten", true },
      {49, "B", 5, "IN/CH/KO", "Heilkunde Seele", false },
      {50, "D", 5, "KL/FF/FF", "Heilkunde Wunden", true },
      {51, "B", 5, "FF/GE/KK", "Holzbearbeitung", true },
      {52, "A", 5, "IN/FF/FF", "Lebensmittelbearbeitung", true },
      {53, "B", 5, "FF/GE/KO", "Lederbearbeitung", true },
      {54, "A", 5, "IN/FF/FF", "Malen & Zeichnen", true },
      {55, "C", 5, "FF/KO/KK", "Metallbearbeitung", true },
      {56, "A", 5, "CH/FF/KO", "Musizieren", true },
      {57, "C", 5, "IN/FF/FF", "Schlösserknacken", true },
      {58, "A", 5, "FF/FF/KK", "Steinbearbeitung", true }
    ])
  end
end
