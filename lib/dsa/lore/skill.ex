defmodule Dsa.Lore.Skill do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

  schema "skills" do
    field :name, :string
    field :category, :string, default: "Zauber"
    field :e1, :string
    field :e2, :string
    field :e3, :string
    field :be, :boolean
    field :sf, :string

    many_to_many :characters, Dsa.Accounts.Character,
      join_through: Dsa.Accounts.CharacterSkill,
      on_replace: :delete
  end

  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:name, :category, :e1, :e2, :e3, :be, :sf])
    |> validate_required([:name, :category, :e1, :e2, :e3, :sf])
    |> validate_length(:name, max: 30)
    |> validate_inclusion(:category, talent_categories())
    |> validate_inclusion(:e1, base_value_options())
    |> validate_inclusion(:e2, base_value_options())
    |> validate_inclusion(:e3, base_value_options())
    |> validate_inclusion(:sf, sf_values())
  end

  def entries do
    [
      # Körper
      { 1, "B", "Körper", "MU/IN/GE", "Fliegen", true },
      { 2, "A", "Körper", "MU/CH/FF", "Gaukeleien", true },
      { 3, "B", "Körper", "MU/GE/KK", "Klettern", true },
      { 4, "D", "Körper", "GE/GE/KO", "Körperbeherrschung", true },
      { 5, "B", "Körper", "KO/KK/KK", "Kraftakt", true },
      { 6, "B", "Körper", "CH/GE/KK", "Reiten", true },
      { 7, "B", "Körper", "GE/KO/KK", "Schwimmen", true },
      { 8, "D", "Körper", "MU/MU/KO", "Selbstbeherrschung", false },
      { 9, "A", "Körper", "KL/CH/KO", "Singen", nil },
      { 10, "D", "Körper", "KL/IN/IN", "Sinnesschärfe", nil },
      { 11, "A", "Körper", "KL/CH/GE", "Tanzen", true },
      { 12, "B", "Körper", "MU/FF/GE", "Taschendiebstahl", true },
      { 13, "C", "Körper", "MU/IN/GE", "Verbergen", true },
      { 14, "A", "Körper", "KL/KO/KK", "Zechen", false },

      # Gesellschaft
      { 15, "B", "Gesellschaft", "MU/KL/CH", "Bekehren / Überzeugen", false },
      { 16, "B", "Gesellschaft", "MU/CH/CH", "Betören", nil },
      { 17, "B", "Gesellschaft", "MU/IN/CH", "Einschüchtern", false },
      { 18, "B", "Gesellschaft", "KL/IN/CH", "Etikette", nil },
      { 19, "C", "Gesellschaft", "KL/IN/CH", "Gassenwissen", nil },
      { 20, "C", "Gesellschaft", "KL/IN/CH", "Menschenkenntnis", false },
      { 21, "C", "Gesellschaft", "MU/IN/CH", "Überreden", false },
      { 22, "B", "Gesellschaft", "IN/CH/GE", "Verkleiden", nil },
      { 23, "D", "Gesellschaft", "MU/IN/CH", "Willenskraft", false },

      # Talents: Nature
      { 24, "C", "Natur", "MU/IN/CH", "Fährtensuchen", true },
      { 25, "A", "Natur", "KL/FF/KK", "Fesseln", nil },
      { 26, "A", "Natur", "FF/GE/KO", "Fischen & Angeln", nil },
      { 27, "B", "Natur", "KL/IN/IN", "Orientierung", false },
      { 28, "C", "Natur", "KL/FF/KO", "Pflanzenkunde", nil },
      { 29, "C", "Natur", "MU/MU/CH", "Tierkunde", true },
      { 30, "C", "Natur", "MU/GE/KO", "Wildnisleben", true },

      # Talents: Knowledge
      { 31, "A", "Wissen", "KL/KL/IN", "Brett- & Glücksspiel", false },
      { 32, "B", "Wissen", "KL/KL/IN", "Geographie", false },
      { 33, "B", "Wissen", "KL/KL/IN", "Geschichtswissen", false },
      { 34, "B", "Wissen", "KL/KL/IN", "Götter & Kulte", false },
      { 35, "B", "Wissen", "MU/KL/IN", "Kriegskunst", false },
      { 36, "C", "Wissen", "KL/KL/IN", "Magiekunde", false },
      { 37, "B", "Wissen", "KL/KL/FF", "Mechanik", false },
      { 38, "A", "Wissen", "KL/KL/IN", "Rechnen", false },
      { 39, "A", "Wissen", "KL/KL/IN", "Rechtskunde", false },
      { 40, "B", "Wissen", "KL/KL/IN", "Sagen & Legenden", false },
      { 41, "B", "Wissen", "KL/KL/IN", "Sphärenkunde", false },
      { 42, "A", "Wissen", "KL/KL/IN", "Sternkunde", false },

      # Talents: Crafting
      { 43, "C", "Handwerk", "MU/KL/FF", "Alchimie", true },
      { 44, "B", "Handwerk", "FF/GE/KK", "Boote & Schiffe", true },
      { 45, "A", "Handwerk", "CH/FF/KO", "Fahrzeuge", true },
      { 46, "B", "Handwerk", "KL/IN/CH", "Handel", false },
      { 47, "B", "Handwerk", "MU/KL/IN", "Heilkunde Gift", true },
      { 48, "B", "Handwerk", "MU/IN/KO", "Heilkunde Krankheiten", true },
      { 49, "B", "Handwerk", "IN/CH/KO", "Heilkunde Seele", false },
      { 50, "D", "Handwerk", "KL/FF/FF", "Heilkunde Wunden", true },
      { 51, "B", "Handwerk", "FF/GE/KK", "Holzbearbeitung", true },
      { 52, "A", "Handwerk", "IN/FF/FF", "Lebensmittelbearbeitung", true },
      { 53, "B", "Handwerk", "FF/GE/KO", "Lederbearbeitung", true },
      { 54, "A", "Handwerk", "IN/FF/FF", "Malen & Zeichnen", true },
      { 55, "C", "Handwerk", "FF/KO/KK", "Metallbearbeitung", true },
      { 56, "A", "Handwerk", "CH/FF/KO", "Musizieren", true },
      { 57, "C", "Handwerk", "IN/FF/FF", "Schlösserknacken", true },
      { 59, "A", "Handwerk", "FF/FF/KK", "Steinbearbeitung", true }
    ]
    |> Enum.map(fn {id, sf, category, probe, name, be} ->
        [e1, e2, e3] =
          case String.split(probe, "/") do
            [e1] -> [e1, nil, nil]
            [e1, e2] -> [e1, e2, nil]
            [e1, e2, e3] -> [e1, e2, e3]
          end

        %{id: id, name: name, sf: sf, e1: e1, e2: e2, e3: e3, category: category, be: be}
      end)
  end
end
