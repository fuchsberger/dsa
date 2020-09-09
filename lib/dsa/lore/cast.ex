defmodule Dsa.Lore.Cast do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

  schema "casts" do
    field :name, :string
    field :tareget, :string
    field :cost_initial, :integer
    field :type, :integer, default: 1 # 1 Zauberspruch
    field :e1, :string
    field :e2, :string
    field :e3, :string
    field :be, :boolean
    field :duration
    field :category, :integer
    field :range, :integer
    field :sf, :string

    many_to_many :characters, Dsa.Accounts.Character,
      join_through: Dsa.Accounts.CharacterSkill,
      on_replace: :delete
  end

  @required ~w(name category e1 e2 e3 sf)a
  @optional ~w(e1 e2 e3 sf)a
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:name, max: 30)
    |> validate_number(:type, greater_than_or_equal_to: 1, less_than_or_equal_to: 7)
    |> validate_inclusion(:e1, base_value_options())
    |> validate_inclusion(:e2, base_value_options())
    |> validate_inclusion(:e3, base_value_options())
    |> validate_inclusion(:sf, sf_values())
    |> unique_constraint(:name)
  end

  def entries do
    [
      # Zauberformeln (1)
      {"B", 1, "MU/IN/GE", "Fliegen", true },
      {"A", 1, "MU/CH/FF", "Gaukeleien", true },
      {"B", 1, "MU/GE/KK", "Klettern", true },
      {"D", 1, "GE/GE/KO", "Körperbeherrschung", true },
      {"B", 1, "KO/KK/KK", "Kraftakt", true },
      {"B", 1, "CH/GE/KK", "Reiten", true },
      {"B", 1, "GE/KO/KK", "Schwimmen", true },
      {"D", 1, "MU/MU/KO", "Selbstbeherrschung", false },
      {"A", 1, "KL/CH/KO", "Singen", nil },
      {"D", 1, "KL/IN/IN", "Sinnesschärfe", nil },
      {"A", 1, "KL/CH/GE", "Tanzen", true },
      {"B", 1, "MU/FF/GE", "Taschendiebstahl", true },
      {"C", 1, "MU/IN/GE", "Verbergen", true },
      {"A", 1, "KL/KO/KK", "Zechen", false },

      # Gesellschaft
      {"B", 2, "MU/KL/CH", "Bekehren / Überzeugen", false },
      {"B", 2, "MU/CH/CH", "Betören", nil },
      {"B", 2, "MU/IN/CH", "Einschüchtern", false },
      {"B", 2, "KL/IN/CH", "Etikette", nil },
      {"C", 2, "KL/IN/CH", "Gassenwissen", nil },
      {"C", 2, "KL/IN/CH", "Menschenkenntnis", false },
      {"C", 2, "MU/IN/CH", "Überreden", false },
      {"B", 2, "IN/CH/GE", "Verkleiden", nil },
      {"D", 2, "MU/IN/CH", "Willenskraft", false },

      # Talents: Nature
      {"C", 3, "MU/IN/CH", "Fährtensuchen", true },
      {"A", 3, "KL/FF/KK", "Fesseln", nil },
      {"A", 3, "FF/GE/KO", "Fischen & Angeln", nil },
      {"B", 3, "KL/IN/IN", "Orientierung", false },
      {"C", 3, "KL/FF/KO", "Pflanzenkunde", nil },
      {"C", 3, "MU/MU/CH", "Tierkunde", true },
      {"C", 3, "MU/GE/KO", "Wildnisleben", true },

      # Talents: Knowledge
      {"A", 4, "KL/KL/IN", "Brett- & Glücksspiel", false },
      {"B", 4, "KL/KL/IN", "Geographie", false },
      {"B", 4, "KL/KL/IN", "Geschichtswissen", false },
      {"B", 4, "KL/KL/IN", "Götter & Kulte", false },
      {"B", 4, "MU/KL/IN", "Kriegskunst", false },
      {"C", 4, "KL/KL/IN", "Magiekunde", false },
      {"B", 4, "KL/KL/FF", "Mechanik", false },
      {"A", 4, "KL/KL/IN", "Rechnen", false },
      {"A", 4, "KL/KL/IN", "Rechtskunde", false },
      {"B", 4, "KL/KL/IN", "Sagen & Legenden", false },
      {"B", 4, "KL/KL/IN", "Sphärenkunde", false },
      {"A", 4, "KL/KL/IN", "Sternkunde", false },

      # Talents: Crafting
      {"C", 5, "MU/KL/FF", "Alchimie", true },
      {"B", 5, "FF/GE/KK", "Boote & Schiffe", true },
      {"A", 5, "CH/FF/KO", "Fahrzeuge", true },
      {"B", 5, "KL/IN/CH", "Handel", false },
      {"B", 5, "MU/KL/IN", "Heilkunde Gift", true },
      {"B", 5, "MU/IN/KO", "Heilkunde Krankheiten", true },
      {"B", 5, "IN/CH/KO", "Heilkunde Seele", false },
      {"D", 5, "KL/FF/FF", "Heilkunde Wunden", true },
      {"B", 5, "FF/GE/KK", "Holzbearbeitung", true },
      {"A", 5, "IN/FF/FF", "Lebensmittelbearbeitung", true },
      {"B", 5, "FF/GE/KO", "Lederbearbeitung", true },
      {"A", 5, "IN/FF/FF", "Malen & Zeichnen", true },
      {"C", 5, "FF/KO/KK", "Metallbearbeitung", true },
      {"A", 5, "CH/FF/KO", "Musizieren", true },
      {"C", 5, "IN/FF/FF", "Schlösserknacken", true },
      {"A", 5, "FF/FF/KK", "Steinbearbeitung", true }
    ]
    |> Enum.map(fn {sf, category, probe, name, be} ->
        [e1, e2, e3] =
          case String.split(probe, "/") do
            [e1] -> [e1, nil, nil]
            [e1, e2] -> [e1, e2, nil]
            [e1, e2, e3] -> [e1, e2, e3]
          end

        %{name: name, sf: sf, e1: e1, e2: e2, e3: e3, category: category, be: be}
      end)
  end
end
