defmodule Dsa.Data.Disadvantage do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  import Ecto.Changeset
  import DsaWeb.DsaHelpers, only: [roman: 1]

  @table :disadvantages

  schema "disadvantages" do
    field :disadvantage_id, :integer
    field :details, :string
    field :level, :integer
    field :ap, :integer
    belongs_to :character, Dsa.Accounts.Character
  end

  @fields ~w(disadvantage_id character_id level ap)a
  def changeset(disadvantage, params \\ %{}) do
    disadvantage
    |> cast(params, [:details | @fields])
    |> validate_required(@fields)
    |> validate_length(:details, max: 50)
    |> validate_number(:disadvantage_id, greater_than: 0, less_than_or_equal_to: count())
    |> validate_ap()
    |> validate_number(:ap, less_than: 0)
    |> foreign_key_constraint(:character_id)
  end

  def validate_ap(changeset) do
    id = get_field(changeset, :disadvantage_id)
    case fixed_ap(id) do
      true -> put_change(changeset, :ap, get_field(changeset, :level) * ap(id))
      false -> changeset
    end
  end

  def count, do: 52
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(cdisadvantages) do
    list()
    |> Enum.map(fn {id, _level, name, _ap, _details, _fixed_ap} -> {name, id} end)
    |> Enum.reject(fn {_name, id} ->
        Enum.member?(Enum.map(cdisadvantages, & &1.disadvantage_id), id)
      end)
  end

  def level_options(id), do: Enum.map(1..level(id), & {roman(&1), &1})

  def level(id), do: :ets.lookup_element(@table, id, 2)
  def name(id), do: :ets.lookup_element(@table, id, 3)
  def ap(id), do: :ets.lookup_element(@table, id, 4)
  def details(id), do: :ets.lookup_element(@table, id, 5)
  def fixed_ap(id), do: :ets.lookup_element(@table, id, 6)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, level, name, ap, details, fixed_ap}
      {1, 3, "Angst vor", -8, true, true},
      {2, 3, "Arm", -1, false, true},
      {3, 1, "Artefaktgebunden", -10, false, true},
      {4, 1, "Behäbig", -4, false, true},
      {5, 1, "Blind", -50, false, true},
      {6, 1, "Blutrausch", -10, false, true},
      {7, 1, "Eingeschränkter Sinn", -2, true, false},
      {8, 1, "Farbenblind", -2, false, true},
      {9, 1, "Fettleibig", -25, false, true},
      {10, 2, "Giftanfällig", -5, false, true},
      {11, 2, "Hässlich", -10, false, true},
      {12, 1, "Hitzeempfindlich", -3, false, true},
      {13, 1, "Kälteempfindlich", -3, false, true},
      {14, 1, "Keine Flugsalbe", -25, false, true},
      {15, 1, "Kein Vertrauter", -25, false, true},
      {16, 1, "Körpergebundene Kraft", -5, false, true},
      {17, 1, "Körperliche Auffälligkeit", -2, true, true},
      {18, 2, "Krankheitsanfällig", -5, false, true},
      {19, 1, "Lästige Mindergeister", -20, false, true},
      {20, 1, "Lichtempfindlich", -20, false, true},
      {21, 1, "Magische Einschränkung", -30, true, true},
      {22, 1, "Nachtblind", -10, false, true},
      {23, 7, "Niedrige Astralkraft", -2, false, true},
      {24, 7, "Niedrige Karmalkraft", -2, false, true},
      {25, 7, "Niedrige Lebenskraft", -2, false, true},
      {26, 1, "Niedrige Seelenkraft", -25, false, true},
      {27, 1, "Niedrige Zähigkeit", -25, false, true},
      {28, 3, "Pech", -20, false, true},
      {29, 1, "Pechmagnet", -5, false, true},
      {30, 1, "Persönlichkeitsschwächen", -5, true, false},
      {31, 3, "Prinzipientreue", -10, true, true},
      {32, 1, "Schlafwandler", -10, false, true},
      {33, 1, "Schlechte Angewohnheit", -2, true, true},
      {34, 1, "Schlechte Eigenschaft", -5, true, false},
      {35, 3, "Schlechte Regeneration (Astralenergie)", -10, false, true},
      {36, 3, "Schlechte Regeneration (Karmaenergie)", -10, false, true},
      {37, 3, "Schlechte Regeneration (Lebensenergie)", -10, false, true},
      {38, 1, "Schwacher Astralkörper", -15, false, true},
      {39, 1, "Schwacher Karmalkörper", -15, false, true},
      {40, 1, "Sensibler Geruchssinn", -10, false, true},
      {41, 1, "Sprachfehler", -15, false, true},
      {42, 1, "Stigma", -10, true, true},
      {43, 1, "Stumm", -40, false, true},
      {44, 1, "Taub", -40, false, true},
      {45, 1, "Unfähig", -1, true, false},
      {46, 1, "Unfrei", -8, false, true},
      {47, 1, "Verpflichtungen", -10, true, true},
      {48, 1, "Verstümmelt", -5, true, false},
      {49, 1, "Wahrer Name", -10, false, true},
      {50, 1, "Wilde Magie", -10, false, true},
      {51, 2, "Zauberanfällig", -12, false, true},
      {52, 1, "Zerbrechlich", -20, false, true},
    ])
  end
end
