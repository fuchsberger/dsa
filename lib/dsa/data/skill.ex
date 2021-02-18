defmodule Dsa.Data.Skill do
  @moduledoc """
  CharacterSpecies module
  """
  @table :skills

  require Logger

  def count, do: 110
  def list, do: :ets.tab2list(@table)

  def field(id), do: String.to_atom("t#{id}")

  def fields, do: Enum.map(1..count(), &String.to_atom("t#{&1}"))

  def options,
    do: Enum.map(list(), fn {id, _sf, _category, _t1, _t2, _t3, name, _be} -> {name, id} end)

  def sf(id), do: :ets.lookup_element(@table, id, 2)
  def category(id), do: :ets.lookup_element(@table, id, 3)

  def probe(id) do
    id
    |> traits()
    |> Enum.map_join("/", &(Atom.to_string(&1) |> String.upcase()))
  end

  def traits(id), do: Enum.map([4, 5, 6], &:ets.lookup_element(@table, id, &1))

  def name(id), do: :ets.lookup_element(@table, id, 7)
  def be(id), do: :ets.lookup_element(@table, id, 8)

  def seed do
    :ets.new(@table, [:ordered_set, :protected, :named_table])

    :ets.insert(@table, [
      # {id, sf, category, _t1, _t2, _t3, name, be}
      # Körper
      {1, :B, 1, :mu, :in, :ge, "Fliegen", true},
      {2, :A, 1, :mu, :ch, :ff, "Gaukeleien", true},
      {3, :B, 1, :mu, :ge, :kk, "Klettern", true},
      {4, :D, 1, :ge, :ge, :ko, "Körperbeherrschung", true},
      {5, :B, 1, :ko, :kk, :kk, "Kraftakt", true},
      {6, :B, 1, :ch, :ge, :kk, "Reiten", true},
      {7, :B, 1, :ge, :ko, :kk, "Schwimmen", true},
      {8, :D, 1, :mu, :mu, :ko, "Selbstbeherrschung", false},
      {9, :A, 1, :kl, :ch, :ko, "Singen", nil},
      {10, :D, 1, :kl, :in, :in, "Sinnesschärfe", nil},
      {11, :A, 1, :kl, :ch, :ge, "Tanzen", true},
      {12, :B, 1, :mu, :ff, :ge, "Taschendiebstahl", true},
      {13, :C, 1, :mu, :in, :ge, "Verbergen", true},
      {14, :A, 1, :kl, :ko, :kk, "Zechen", false},
      # Gesellschaft
      {15, :B, 2, :mu, :kl, :ch, "Bekehren / Überzeugen", false},
      {16, :B, 2, :mu, :ch, :ch, "Betören", nil},
      {17, :B, 2, :mu, :in, :ch, "Einschüchtern", false},
      {18, :B, 2, :kl, :in, :ch, "Etikette", nil},
      {19, :C, 2, :kl, :in, :ch, "Gassenwissen", nil},
      {20, :C, 2, :kl, :in, :ch, "Menschenkenntnis", false},
      {21, :C, 2, :mu, :in, :ch, "Überreden", false},
      {22, :B, 2, :in, :ch, :ge, "Verkleiden", nil},
      {23, :D, 2, :mu, :in, :ch, "Willenskraft", false},
      # Talents: Nature
      {24, :C, 3, :mu, :in, :ch, "Fährtensuchen", true},
      {25, :A, 3, :kl, :ff, :kk, "Fesseln", nil},
      {26, :A, 3, :ff, :ge, :ko, "Fischen & Angeln", nil},
      {27, :B, 3, :kl, :in, :in, "Orientierung", false},
      {28, :C, 3, :kl, :ff, :ko, "Pflanzenkunde", nil},
      {29, :C, 3, :mu, :mu, :ch, "Tierkunde", true},
      {30, :C, 3, :mu, :ge, :ko, "Wildnisleben", true},
      # Talents: Knowledge
      {31, :A, 4, :kl, :kl, :in, "Brett- & Glücksspiel", false},
      {32, :B, 4, :kl, :kl, :in, "Geographie", false},
      {33, :B, 4, :kl, :kl, :in, "Geschichtswissen", false},
      {34, :B, 4, :kl, :kl, :in, "Götter & Kulte", false},
      {35, :B, 4, :mu, :kl, :in, "Kriegskunst", false},
      {36, :C, 4, :kl, :kl, :in, "Magiekunde", false},
      {37, :B, 4, :kl, :kl, :ff, "Mechanik", false},
      {38, :A, 4, :kl, :kl, :in, "Rechnen", false},
      {39, :A, 4, :kl, :kl, :in, "Rechtskunde", false},
      {40, :B, 4, :kl, :kl, :in, "Sagen & Legenden", false},
      {41, :B, 4, :kl, :kl, :in, "Sphärenkunde", false},
      {42, :A, 4, :kl, :kl, :in, "Sternkunde", false},
      # Talents: Crafting
      {43, :C, 5, :mu, :kl, :ff, "Alchimie", true},
      {44, :B, 5, :ff, :ge, :kk, "Boote & Schiffe", true},
      {45, :A, 5, :ch, :ff, :ko, "Fahrzeuge", true},
      {46, :B, 5, :kl, :in, :ch, "Handel", false},
      {47, :B, 5, :mu, :kl, :in, "Heilkunde Gift", true},
      {48, :B, 5, :mu, :in, :ko, "Heilkunde Krankheiten", true},
      {49, :B, 5, :in, :ch, :ko, "Heilkunde Seele", false},
      {50, :D, 5, :kl, :ff, :ff, "Heilkunde Wunden", true},
      {51, :B, 5, :ff, :ge, :kk, "Holzbearbeitung", true},
      {52, :A, 5, :in, :ff, :ff, "Lebensmittelbearbeitung", true},
      {53, :B, 5, :ff, :ge, :ko, "Lederbearbeitung", true},
      {54, :A, 5, :in, :ff, :ff, "Malen & Zeichnen", true},
      {55, :C, 5, :ff, :ko, :kk, "Metallbearbeitung", true},
      {56, :A, 5, :ch, :ff, :ko, "Musizieren", true},
      {57, :C, 5, :in, :ff, :ff, "Schlösserknacken", true},
      {58, :A, 5, :ff, :ff, :kk, "Steinbearbeitung", true},
      {59, :A, 5, :kl, :ff, :ff, "Stoffbearbeitung", true},
      # Spells
      {60, :B, 999, :kl, :in, :ff, "Adlerauge", nil},
      {61, :D, 999, :kl, :in, :ff, "Arcanovi", nil},
      {62, :C, 999, :kl, :kl, :in, "Analys Arkanstruktur", nil},
      {63, :C, 999, :kl, :in, :ff, "Armatrutz", nil},
      {64, :B, 999, :kl, :in, :ff, "Axxeleratus", nil},
      {65, :B, 999, :kl, :in, :ff, "Balsam Salabunde", nil},
      {66, :B, 999, :mu, :in, :ch, "Bannbaladin", nil},
      {67, :C, 999, :mu, :kl, :in, "Blick in die Gedanken", nil},
      {68, :A, 999, :mu, :in, :ch, "Blitz dich find", nil},
      {69, :C, 999, :kl, :in, :ko, "Corpofesso", nil},
      {70, :B, 999, :mu, :kl, :ch, "Disruptivo", nil},
      {71, :C, 999, :mu, :ch, :ko, "Dschinnenruf", nil},
      {72, :C, 999, :kl, :in, :ch, "Duplicatus", nil},
      {73, :B, 999, :mu, :ch, :ko, "Elementarer Diener", nil},
      {74, :B, 999, :mu, :kl, :in, "Falkenauge", nil},
      {75, :A, 999, :mu, :kl, :ch, "Flim Flam", nil},
      {76, :C, 999, :kl, :in, :ko, "Fulminictus", nil},
      {77, :B, 999, :mu, :kl, :ch, "Gardianum", nil},
      {78, :B, 999, :mu, :in, :ch, "Große Gier", nil},
      {79, :B, 999, :kl, :in, :ch, "Harmlose Gestalt", nil},
      {80, :B, 999, :kl, :in, :ko, "Hexengalle", nil},
      {81, :A, 999, :kl, :in, :ko, "Hexenkrallen", nil},
      {82, :B, 999, :mu, :in, :ch, "Horriphobus", nil},
      {83, :C, 999, :mu, :kl, :ch, "Ignifaxius", nil},
      {84, :C, 999, :mu, :ch, :ko, "Invocatio Maior", nil},
      {85, :A, 999, :mu, :ch, :ko, "Invocatio Minima", nil},
      {86, :B, 999, :mu, :ch, :ko, "Invocatio Minor", nil},
      {87, :A, 999, :kl, :in, :ko, "Katzenaugen", nil},
      {88, :A, 999, :kl, :in, :ko, "Krötensprung", nil},
      {89, :A, 999, :mu, :kl, :ch, "Manifesto", nil},
      {90, :A, 999, :kl, :ff, :kk, "Manus Miracula", nil},
      {91, :B, 999, :kl, :ff, :kk, "Motoricus", nil},
      {92, :C, 999, :mu, :kl, :ch, "Nebelwand", nil},
      {93, :B, 999, :kl, :in, :ch, "Oculus Illusionis", nil},
      {94, :A, 999, :kl, :in, :in, "Odem Arcanum", nil},
      {95, :B, 999, :kl, :in, :ko, "Paralysis", nil},
      {96, :B, 999, :mu, :kl, :in, "Penetrizzel", nil},
      {97, :B, 999, :kl, :in, :ff, "Psychostabilis", nil},
      {98, :B, 999, :kl, :ff, :kk, "Radau", nil},
      {99, :B, 999, :mu, :in, :ch, "Respondami", nil},
      {100, :C, 999, :kl, :in, :ko, "Salander", nil},
      {101, :A, 999, :mu, :in, :ch, "Sanftmut", nil},
      {102, :B, 999, :kl, :in, :ko, "Satuarias Herrlichkeit", nil},
      {103, :B, 999, :kl, :ff, :kk, "Silentium", nil},
      {104, :B, 999, :mu, :in, :ch, "Somnigravis", nil},
      {105, :A, 999, :kl, :in, :ko, "Spinnenlauf", nil},
      {106, :B, 999, :kl, :ff, :kk, "Spurlos", nil},
      {107, :C, 999, :mu, :ch, :ko, "Transversalis", nil},
      {108, :B, 999, :kl, :in, :ko, "Visibili", nil},
      {109, :B, 999, :kl, :in, :ko, "Wasseratem", nil},
      {110, :D, 999, :kl, :in, :ff, "Zauberklinge Geisterspeer", nil}
    ])
  end
end
