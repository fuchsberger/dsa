defmodule Dsa.Data.Skill do
  use Ecto.Schema
  import Ecto.Changeset
  import DsaWeb.DsaHelpers, only: [traits: 0]

  alias Dsa.Type.{SkillCategory, Probe}

  @sf_values ~w(A B C D E)a

  schema "skills" do
    field :name, :string
    field :be, :boolean
    field :category, SkillCategory
    field :probe, Probe
    field :sf, Ecto.Enum, values: @sf_values
    field :t1, Ecto.Enum, values: traits(), virtual: true
    field :t2, Ecto.Enum, values: traits(), virtual: true
    field :t3, Ecto.Enum, values: traits(), virtual: true
  end

  @fields ~w(name sf category t1 t2 t3)a

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:be | @fields])
    |> validate_required(@fields)
    |> validate_length(:name, min: 5, max: 23)
    |> validate_number(:category, greater_than_or_equal_to: 0, less_than_or_equal_to: SkillCategory.count())
    |> validate_number(:probe, greater_than_or_equal_to: 0, less_than_or_equal_to: 512)
    |> validate_inclusion(:sf, @sf_values)
    |> validate_probe()
    |> unique_constraint(:name)
  end

  defp validate_probe(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{t1: t1, t2: t2, t3: t3}} ->
        put_change(changeset, :probe, {t1, t2, t3})

      _ ->
        changeset
    end
  end

  # TODO: TO BE DELETED

  @table :skills

  require Logger

  def count, do: 59
  def list, do: :ets.tab2list(@table)

  def field(id), do: String.to_atom("t#{id}")

  def fields, do: Enum.map(1..count(), & String.to_atom("t#{&1}"))

  def options, do:  Enum.map(list(), fn {id, _sf, _category, _t1, _t2, _t3, name, _be} -> {name, id} end)

  def sf(id), do: :ets.lookup_element(@table, id, 2)
  def category(id), do: :ets.lookup_element(@table, id, 3)

  def probe(id) do
    id
    |> traits()
    |> Enum.map_join("/", & Atom.to_string(&1) |> String.upcase())
  end

  def traits(id), do: Enum.map([4, 5, 6], & :ets.lookup_element(@table, id, &1))

  def name(id), do: :ets.lookup_element(@table, id, 7)
  def be(id), do: :ets.lookup_element(@table, id, 8)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, sf, category, _t1, _t2, _t3, name, be}
      # Körper
      { 1, :B, 1, :mu, :in, :ge, "Fliegen", true },
      { 2, :A, 1, :mu, :ch, :ff, "Gaukeleien", true },
      { 3, :B, 1, :mu, :ge, :kk, "Klettern", true },
      { 4, :D, 1, :ge, :ge, :ko, "Körperbeherrschung", true },
      { 5, :B, 1, :ko, :kk, :kk, "Kraftakt", true },
      { 6, :B, 1, :ch, :ge, :kk, "Reiten", true },
      { 7, :B, 1, :ge, :ko, :kk, "Schwimmen", true },
      { 8, :D, 1, :mu, :mu, :ko, "Selbstbeherrschung", false },
      { 9, :A, 1, :kl, :ch, :ko, "Singen", nil },
      {10, :D, 1, :kl, :in, :in, "Sinnesschärfe", nil },
      {11, :A, 1, :kl, :ch, :ge, "Tanzen", true },
      {12, :B, 1, :mu, :ff, :ge, "Taschendiebstahl", true },
      {13, :C, 1, :mu, :in, :ge, "Verbergen", true },
      {14, :A, 1, :kl, :ko, :kk, "Zechen", false },
      # Gesellschaft
      {15, :B, 2, :mu, :kl, :ch, "Bekehren / Überzeugen", false },
      {16, :B, 2, :mu, :ch, :ch, "Betören", nil },
      {17, :B, 2, :mu, :in, :ch, "Einschüchtern", false },
      {18, :B, 2, :kl, :in, :ch, "Etikette", nil },
      {19, :C, 2, :kl, :in, :ch, "Gassenwissen", nil },
      {20, :C, 2, :kl, :in, :ch, "Menschenkenntnis", false },
      {21, :C, 2, :mu, :in, :ch, "Überreden", false },
      {22, :B, 2, :in, :ch, :ge, "Verkleiden", nil },
      {23, :D, 2, :mu, :in, :ch, "Willenskraft", false },
      # Talents: Nature
      {24, :C, 3, :mu, :in, :ch, "Fährtensuchen", true },
      {25, :A, 3, :kl, :ff, :kk, "Fesseln", nil },
      {26, :A, 3, :ff, :ge, :ko, "Fischen & Angeln", nil },
      {27, :B, 3, :kl, :in, :in, "Orientierung", false },
      {28, :C, 3, :kl, :ff, :ko, "Pflanzenkunde", nil },
      {29, :C, 3, :mu, :mu, :ch, "Tierkunde", true },
      {30, :C, 3, :mu, :ge, :ko, "Wildnisleben", true },
      # Talents: Knowledge
      {31, :A, 4, :kl, :kl, :in, "Brett- & Glücksspiel", false },
      {32, :B, 4, :kl, :kl, :in, "Geographie", false },
      {33, :B, 4, :kl, :kl, :in, "Geschichtswissen", false },
      {34, :B, 4, :kl, :kl, :in, "Götter & Kulte", false },
      {35, :B, 4, :mu, :kl, :in, "Kriegskunst", false },
      {36, :C, 4, :kl, :kl, :in, "Magiekunde", false },
      {37, :B, 4, :kl, :kl, :ff, "Mechanik", false },
      {38, :A, 4, :kl, :kl, :in, "Rechnen", false },
      {39, :A, 4, :kl, :kl, :in, "Rechtskunde", false },
      {40, :B, 4, :kl, :kl, :in, "Sagen & Legenden", false },
      {41, :B, 4, :kl, :kl, :in, "Sphärenkunde", false },
      {42, :A, 4, :kl, :kl, :in, "Sternkunde", false },
      # Talents: Crafting
      {43, :C, 5, :mu, :kl, :ff, "Alchimie", true },
      {44, :B, 5, :ff, :ge, :kk, "Boote & Schiffe", true },
      {45, :A, 5, :ch, :ff, :ko, "Fahrzeuge", true },
      {46, :B, 5, :kl, :in, :ch, "Handel", false },
      {47, :B, 5, :mu, :kl, :in, "Heilkunde Gift", true },
      {48, :B, 5, :mu, :in, :ko, "Heilkunde Krankheiten", true },
      {49, :B, 5, :in, :ch, :ko, "Heilkunde Seele", false },
      {50, :D, 5, :kl, :ff, :ff, "Heilkunde Wunden", true },
      {51, :B, 5, :ff, :ge, :kk, "Holzbearbeitung", true },
      {52, :A, 5, :in, :ff, :ff, "Lebensmittelbearbeitung", true },
      {53, :B, 5, :ff, :ge, :ko, "Lederbearbeitung", true },
      {54, :A, 5, :in, :ff, :ff, "Malen & Zeichnen", true },
      {55, :C, 5, :ff, :ko, :kk, "Metallbearbeitung", true },
      {56, :A, 5, :ch, :ff, :ko, "Musizieren", true },
      {57, :C, 5, :in, :ff, :ff, "Schlösserknacken", true },
      {58, :A, 5, :ff, :ff, :kk, "Steinbearbeitung", true },
      {59, :A, 5, :kl, :ff, :ff, "Stoffbearbeitung", true }
    ])
  end
end
