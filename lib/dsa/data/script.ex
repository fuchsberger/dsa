defmodule Dsa.Data.Script do

  use Phoenix.HTML
  use Ecto.Schema
  import Ecto.Changeset

  @table :scripts

  @primary_key false
  schema "scripts" do
    field :script_id, :integer, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  @fields ~w(character_id script_id)a
  def changeset(script, params \\ %{}) do
    script
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:script_id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :script_id])
  end

  def count, do: 16
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(cscripts) do
    list()
    |> Enum.map(fn {id, name, _ap, _alphabet, _languages} -> {name, id} end)
    |> Enum.reject(fn {_name, id} -> Enum.member?(Enum.map(cscripts, & &1.script_id), id) end)
  end

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def ap(id), do: :ets.lookup_element(@table, id, 3)

  def tooltip(id) do
    {_id, _name, _ap, alphabet, languages} = get(id)

    ~E"""
    <p class="small mb-1"><strong>Alphabet:</strong> <%= alphabet %></p>
    <p class="small mb-0"><strong>Zugeh. Sprachen:</strong> <%= languages %></p>
    """
  end

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      #{id, name, ap, alphabet, languages}
      {1, "Altes Alaani", 4, "etwa 1.000 Wort- und Silbenzeichen", "Alaani (sehr alte Form)"},
      {2, "Angram-Bilderschrift", 4, "Bilderschrift", "Angram"},
      {3, "Chrmk", 4, "5.000 Wort- und Deutzeichen", "Alaani, Kemi, Rssahh, Ur-Tulamidya, Zelemja"},
      {4, "Chuchas (Protozelemja, Yash-Hualay-Glyphen)", 6, "etwa 20.000 Zeichen", "frühes Rssahh"},
      {5, "Geheiligte Glyphen von Unau", 2, "19 Laut und Deutzeichen", "Tulamidya"},
      {6, "Hjaldingsche Runen", 2, "um 30 Lautzeichen und mehrere Dutzend Piktogramme", "Saga-Thorwalsch"},
      {7, "Imperiale Zeichen", 2, "57 Lautzeichen", "Aureliani, alte Form des Zyklopäischen"},
      {8, "Isdira- und Asdharia-Zeichen", 2, "27 Lautzeichen, dazu subtile Deutzeichen", "Isdira, Asdharia"},
      {9, "Kusliker Zeichen", 2, "31 Lautzeichen", "Garethi"},
      {10, "Nanduria-Zeichen", 2, "26 Lautzeichen", "keine zugeordnete Sprache (aber meist Garethi oder Bosparano)"},
      {11, "Rogolan-Runen", 2, "24 Lautrunen, 4 davon mit geringer Verwendung", "Rogolan"},
      {12, "Thorwalsche Runen", 2, "um 30 Lautzeichen", "Thorwalsch"},
      {13, "Trollische Raumbilderschrift", 6, "dreidimensionale Steinsetzung", "Trollisch"},
      {14, "Tulamidya-Zeichen", 2, "56 Silbenzeichen", "Tulamidya"},
      {15, "Ur-Tulamidya-Zeichen", 2, "etwa 300 Wort-, Deut- und Silbenzeichen", "Ur-Tulamidya"},
      {16, "Zhayad-Zeichen", 2, "mehrere Hundert Laut- und Silbenzeichen", "Zhayad"},
    ])
  end
end
