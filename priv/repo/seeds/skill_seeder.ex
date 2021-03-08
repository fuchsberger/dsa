defmodule Dsa.Repo.Seeds.SkillSeeder do
  alias Dsa.Data
  require Logger

  @skills [
    { 1, :B, :body, :mu, :in, :ge, "Fliegen", true },
    { 2, :A, :body, :mu, :ch, :ff, "Gaukeleien", true },
    { 3, :B, :body, :mu, :ge, :kk, "Klettern", true },
    { 4, :D, :body, :ge, :ge, :ko, "Körperbeherrschung", true },
    { 5, :B, :body, :ko, :kk, :kk, "Kraftakt", true },
    { 6, :B, :body, :ch, :ge, :kk, "Reiten", true },
    { 7, :B, :body, :ge, :ko, :kk, "Schwimmen", true },
    { 8, :D, :body, :mu, :mu, :ko, "Selbstbeherrschung", false },
    { 9, :A, :body, :kl, :ch, :ko, "Singen", nil },
    {10, :D, :body, :kl, :in, :in, "Sinnesschärfe", nil },
    {11, :A, :body, :kl, :ch, :ge, "Tanzen", true },
    {12, :B, :body, :mu, :ff, :ge, "Taschendiebstahl", true },
    {13, :C, :body, :mu, :in, :ge, "Verbergen", true },
    {14, :A, :body, :kl, :ko, :kk, "Zechen", false },
    {15, :B, :social, :mu, :kl, :ch, "Bekehren / Überzeugen", false },
    {16, :B, :social, :mu, :ch, :ch, "Betören", nil },
    {17, :B, :social, :mu, :in, :ch, "Einschüchtern", false },
    {18, :B, :social, :kl, :in, :ch, "Etikette", nil },
    {19, :C, :social, :kl, :in, :ch, "Gassenwissen", nil },
    {20, :C, :social, :kl, :in, :ch, "Menschenkenntnis", false },
    {21, :C, :social, :mu, :in, :ch, "Überreden", false },
    {22, :B, :social, :in, :ch, :ge, "Verkleiden", nil },
    {23, :D, :social, :mu, :in, :ch, "Willenskraft", false },
    {24, :C, :nature, :mu, :in, :ch, "Fährtensuchen", true },
    {25, :A, :nature, :kl, :ff, :kk, "Fesseln", nil },
    {26, :A, :nature, :ff, :ge, :ko, "Fischen & Angeln", nil },
    {27, :B, :nature, :kl, :in, :in, "Orientierung", false },
    {28, :C, :nature, :kl, :ff, :ko, "Pflanzenkunde", nil },
    {29, :C, :nature, :mu, :mu, :ch, "Tierkunde", true },
    {30, :C, :nature, :mu, :ge, :ko, "Wildnisleben", true },
    {31, :A, :knowledge, :kl, :kl, :in, "Brett- & Glücksspiel", false },
    {32, :B, :knowledge, :kl, :kl, :in, "Geographie", false },
    {33, :B, :knowledge, :kl, :kl, :in, "Geschichtswissen", false },
    {34, :B, :knowledge, :kl, :kl, :in, "Götter & Kulte", false },
    {35, :B, :knowledge, :mu, :kl, :in, "Kriegskunst", false },
    {36, :C, :knowledge, :kl, :kl, :in, "Magiekunde", false },
    {37, :B, :knowledge, :kl, :kl, :ff, "Mechanik", false },
    {38, :A, :knowledge, :kl, :kl, :in, "Rechnen", false },
    {39, :A, :knowledge, :kl, :kl, :in, "Rechtskunde", false },
    {40, :B, :knowledge, :kl, :kl, :in, "Sagen & Legenden", false },
    {41, :B, :knowledge, :kl, :kl, :in, "Sphärenkunde", false },
    {42, :A, :knowledge, :kl, :kl, :in, "Sternkunde", false },
    {43, :C, :crafting, :mu, :kl, :ff, "Alchimie", true },
    {44, :B, :crafting, :ff, :ge, :kk, "Boote & Schiffe", true },
    {45, :A, :crafting, :ch, :ff, :ko, "Fahrzeuge", true },
    {46, :B, :crafting, :kl, :in, :ch, "Handel", false },
    {47, :B, :crafting, :mu, :kl, :in, "Heilkunde Gift", true },
    {48, :B, :crafting, :mu, :in, :ko, "Heilkunde Krankheiten", true },
    {49, :B, :crafting, :in, :ch, :ko, "Heilkunde Seele", false },
    {50, :D, :crafting, :kl, :ff, :ff, "Heilkunde Wunden", true },
    {51, :B, :crafting, :ff, :ge, :kk, "Holzbearbeitung", true },
    {52, :A, :crafting, :in, :ff, :ff, "Lebensmittelbearbeitung", true },
    {53, :B, :crafting, :ff, :ge, :ko, "Lederbearbeitung", true },
    {54, :A, :crafting, :in, :ff, :ff, "Malen & Zeichnen", true },
    {55, :C, :crafting, :ff, :ko, :kk, "Metallbearbeitung", true },
    {56, :A, :crafting, :ch, :ff, :ko, "Musizieren", true },
    {57, :C, :crafting, :in, :ff, :ff, "Schlösserknacken", true },
    {58, :A, :crafting, :ff, :ff, :kk, "Steinbearbeitung", true },
    {59, :A, :crafting, :kl, :ff, :ff, "Stoffbearbeitung", true }
  ]

  defp to_map({id, sf, category, t1, t2, t3, name, be}) do
    %{
      id: id,
      sf: sf,
      category: category,
      t1: t1,
      t2: t2,
      t3: t3,
      name: name,
      be: be
    }
  end

  def seed, do: Enum.each(@skills, & Data.create_skill!(to_map(&1)))

  def reseed do
    skills = Data.list_skills()

    Enum.each(@skills, fn skill ->
      attrs = to_map(skill)

      case Enum.find(skills, & &1.id == attrs.id) do
        nil -> Data.create_skill!(attrs)
        skill -> Data.update_skill!(skill, attrs)
      end
    end)
  end
end
