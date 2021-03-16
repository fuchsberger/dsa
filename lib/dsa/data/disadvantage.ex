defmodule Dsa.Data.Disadvantage do
  @moduledoc """
  CharacterDisadvantage module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @table :disadvantages

  schema "disadvantages" do
    field :disadvantage_id, :integer
    field :details, :string
    belongs_to :character, Dsa.Characters.Character
  end

  def changeset(disadvantage, params \\ %{}) do
    disadvantage
    |> cast(params, [:disadvantage_id, :character_id, :details])
    |> validate_required([:disadvantage_id, :character_id])
    |> validate_length(:details, max: 50)
    |> validate_number(:disadvantage_id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
  end

  def count, do: :ets.info(@table, :size)
  def list, do: :ets.tab2list(@table)

  def options, do: Enum.map(list(), fn {id, name, ap, _details} -> {"#{name} (#{ap})", id} end)

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def ap(id), do: :ets.lookup_element(@table, id, 3)
  def details(id), do: :ets.lookup_element(@table, id, 4)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, ap, details}
      {1, "Angst I vor", -8, true},
      {2, "Angst II vor", -16, true},
      {3, "Angst III vor", -24, true},
      {4, "Arm I", -1, false},
      {5, "Arm II", -2, false},
      {6, "Arm III", -3, false},
      {7, "Artefaktgebunden", -10, true},
      {8, "Behäbig", -4, false},
      {5, "Blind", -50, false},
      {6, "Blutrausch", -10, false},
      {7, "Eingeschränkter Sinn: Gehör", -10, false},
      {8, "Eingeschränkter Sinn: Geruch & Geschmack", -6, false},
      {9, "Eingeschränkter Sinn: Sicht", -15, false},
      {10, "Eingeschränkter Sinn: Tastsinn", -2, false},
      {11, "Farbenblind", -2, false},
      {12, "Fettleibig", -25, false},
      {13, "Giftanfällig I", -5, false},
      {14, "Giftanfällig II", -10, false},
      {15, "Hässlich I", -10, false},
      {16, "Hässlich II", -20, false},
      {17, "Hitzeempfindlich", -3, false},
      {18, "Kälteempfindlich", -3, false},
      {19, "Keine Flugsalbe", -25, false},
      {20, "Kein Vertrauter", -25, false},
      {21, "Körpergebundene Kraft", -5, false},
      {22, "Körperliche Auffälligkeit", -2, true},
      {23, "Krankheitsanfällig I", -5, false},
      {24, "Krankheitsanfällig II", -10, false},
      {25, "Lästige Mindergeister", -20, false},
      {26, "Lichtempfindlich", -20, false},
      {27, "Magische Einschränkung", -30, true},
      {28, "Nachtblind", -10, false},
      {29, "Niedrige Astralkraft I", -2, false},
      {30, "Niedrige Astralkraft II", -4, false},
      {31, "Niedrige Astralkraft III", -6, false},
      {32, "Niedrige Astralkraft IV", -8, false},
      {33, "Niedrige Astralkraft V", -10, false},
      {34, "Niedrige Astralkraft V", -12, false},
      {35, "Niedrige Astralkraft VII", -14, false},
      {36, "Niedrige Karmalkraft I", -2, false},
      {37, "Niedrige Karmalkraft II", -4, false},
      {38, "Niedrige Karmalkraft III", -6, false},
      {39, "Niedrige Karmalkraft IV", -8, false},
      {40, "Niedrige Karmalkraft V", -10, false},
      {41, "Niedrige Karmalkraft V", -12, false},
      {42, "Niedrige Karmalkraft VII", -14, false},
      {43, "Niedrige Lebenskraft I", -2, false},
      {44, "Niedrige Lebenskraft II", -4, false},
      {45, "Niedrige Lebenskraft III", -6, false},
      {46, "Niedrige Lebenskraft IV", -8, false},
      {47, "Niedrige Lebenskraft V", -10, false},
      {48, "Niedrige Lebenskraft V", -12, false},
      {49, "Niedrige Lebenskraft VII", -14, false},
      {50, "Niedrige Seelenkraft", -25, false},
      {51, "Niedrige Zähigkeit", -25, false},
      {52, "Pech I", -20, false},
      {53, "Pech II", -40, false},
      {54, "Pech III", -60, false},
      {55, "Pechmagnet", -5, false},
      {56, "Persönlichkeitsschwäche", -5, true},
      {57, "Prinzipientreue I", -10, true},
      {58, "Prinzipientreue II", -20, true},
      {59, "Prinzipientreue III", -30, true},
      {60, "Schlafwandler", -10, false},
      {61, "Schlechte Angewohnheit", -2, true},
      {62, "Schlechte Eigenschaft", -5, true},
      {63, "Schlechte Eigenschaft", -10, true},
      {64, "Schlechte Regeneration (Astralenergie) I", -10, false},
      {65, "Schlechte Regeneration (Astralenergie) II", -20, false},
      {66, "Schlechte Regeneration (Astralenergie) III", -30, false},
      {67, "Schlechte Regeneration (Karmaenergie) I", -10, false},
      {68, "Schlechte Regeneration (Karmaenergie) II", -20, false},
      {69, "Schlechte Regeneration (Karmaenergie) III", -30, false},
      {70, "Schlechte Regeneration (Lebensenergie) I", -10, false},
      {71, "Schlechte Regeneration (Lebensenergie) II", -20, false},
      {72, "Schlechte Regeneration (Lebensenergie) III", -30, false},
      {73, "Schwacher Astralkörper", -15, false},
      {74, "Schwacher Karmalkörper", -15, false},
      {75, "Sensibler Geruchssinn", -10, false},
      {76, "Sprachfehler", -15, false},
      {77, "Stigma", -10, true},
      {78, "Stumm", -40, false},
      {79, "Taub", -40, false},
      {80, "Unfähig: Alchimie", -3, false},
      {81, "Unfähig: Bekehren & Überzeugen", -2, false},
      {82, "Unfähig: Betören", -2, false},
      {83, "Unfähig: Boote & Schiffe", -2, false},
      {84, "Unfähig: Brett & Glücksspiel", -1, false},
      {85, "Unfähig: Einschüchtern", -2, false},
      {86, "Unfähig: Etikette", -2, false},
      {87, "Unfähig: Fährtensuchen", -3, false},
      {88, "Unfähig: Fahrzeuge", -1, false},
      {89, "Unfähig: Fesseln", -1, false},
      {90, "Unfähig: Fischen & Angeln", -1, false},
      {91, "Unfähig: Fliegen", -2, false},
      {92, "Unfähig: Gassenwissen", -3, false},
      {93, "Unfähig: Gaukeleien", -1, false},
      {94, "Unfähig: Geographie", -2, false},
      {95, "Unfähig: Geschichtswissen", -2, false},
      {96, "Unfähig: Götter & Kulte", -2, false},
      {97, "Unfähig: Handel", -2, false},
      {98, "Unfähig: Heilkunde Gift", -2, false},
      {99, "Unfähig: Heilkunde Krankheiten", -2, false},
      {100, "Unfähig: Heilkunde Seele", -2, false},
      {101, "Unfähig: Heilkunde Wunden", -4, false},
      {102, "Unfähig: Holzbearbeitung", -2, false},
      {103, "Unfähig: Klettern", -2, false},
      {104, "Unfähig: Körperbeherrschung", -4, false},
      {105, "Unfähig: Kraftakt", -2, false},
      {106, "Unfähig: Kriegskunst", -2, false},
      {107, "Unfähig: Lebensmittelbearbeitung", -1, false},
      {108, "Unfähig: Lederbearbeitung", -2, false},
      {109, "Unfähig: Magiekunde", -3, false},
      {110, "Unfähig: Malen & Zeichnen", -1, false},
      {111, "Unfähig: Mechanik", -2, false},
      {112, "Unfähig: Menschenkenntnis", -3, false},
      {113, "Unfähig: Metallbearbeitung", -3, false},
      {114, "Unfähig: Musizieren", -1, false},
      {115, "Unfähig: Orientierung", -2, false},
      {116, "Unfähig: Pflanzenkunde", -3, false},
      {117, "Unfähig: Rechnen", -1, false},
      {118, "Unfähig: Rechtskunde", -1, false},
      {119, "Unfähig: Reiten", -2, false},
      {120, "Unfähig: Sagen & Legenden", -2, false},
      {121, "Unfähig: Schlösserknacken", -3, false},
      {122, "Unfähig: Schwimmen", -2, false},
      {123, "Unfähig: Selbstbeherrschung", -4, false},
      {124, "Unfähig: Singen", -1, false},
      {125, "Unfähig: Sinnesschärfe", -4, false},
      {126, "Unfähig: Spärenkunde", -2, false},
      {127, "Unfähig: Steinbearbeitung", -1, false},
      {128, "Unfähig: Sternkunde", -1, false},
      {129, "Unfähig: Stoffbearbeitung", -1, false},
      {130, "Unfähig: Tanzen", -1, false},
      {131, "Unfähig: Taschendiebstahl", -2, false},
      {132, "Unfähig: Tierkunde", -3, false},
      {133, "Unfähig: Überreden", -3, false},
      {134, "Unfähig: Verbergen", -3, false},
      {135, "Unfähig: Verkleiden", -2, false},
      {136, "Unfähig: Wildnisleben", -3, false},
      {137, "Unfähig: Willenskraft", -4, false},
      {138, "Unfähig: Zechen", -1, false},
      {139, "Unfrei", -8, false},
      {140, "Verpflichtungen I", -10, true},
      {140, "Verpflichtungen II", -20, true},
      {140, "Verpflichtungen III", -30, true},
      {141, "Verstümmelt: Einarmig", -30, false},
      {142, "Verstümmelt: Einäugig", -10, false},
      {143, "Verstümmelt: Einbeinig", -30, false},
      {144, "Verstümmelt: Einhändig", -20, false},
      {145, "Verstümmelt: Einohrig", -5, false},
      {146, "Wahrer Name", -10, false},
      {147, "Wilde Magie", -10, false},
      {148, "Zauberanfällig I", -12, false},
      {149, "Zauberanfällig II", -24, false},
      {150, "Zerbrechlich", -20, false}
    ])
  end
end
