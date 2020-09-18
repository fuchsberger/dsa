defmodule Dsa.Data.Advantage do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  import Ecto.Changeset
  import DsaWeb.DsaHelpers, only: [roman: 1]

  @table :advantages

  schema "advantages" do
    field :advantage_id, :integer
    field :details, :string
    field :level, :integer
    field :ap, :integer
    belongs_to :character, Dsa.Accounts.Character
  end

  @fields ~w(advantage_id character_id level ap)a
  def changeset(advantage, params \\ %{}) do
    advantage
    |> cast(params, [:details | @fields])
    |> validate_required(@fields)
    |> validate_length(:details, max: 50)
    |> validate_number(:advantage_id, greater_than: 0, less_than_or_equal_to: count())
    |> validate_ap()
    |> validate_number(:ap, greater_than: 0)
    |> foreign_key_constraint(:character_id)
  end

  def validate_ap(changeset) do
    id = get_field(changeset, :advantage_id)
    case fixed_ap(id) do
      true -> put_change(changeset, :ap, get_field(changeset, :level) * ap(id))
      false -> changeset
    end
  end

  def count, do: 50
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(cadvantages) do
    list()
    |> Enum.map(fn {id, _level, name, _ap, _details, _fixed_ap} -> {name, id} end)
    |> Enum.reject(fn {_name, id} ->
        Enum.member?(Enum.map(cadvantages, & &1.advantage_id), id)
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
      {1, 3, "Adel", 5, true, true},
      {2, 1, "Altersresistenz", 5, false, true},
      {3, 1, "Angenehmer Geruch", 6, false, true},
      {4, 1, "Begabung", 6, true, false},
      {5, 1, "Beidhändig", 15, false, true},
      {6, 2, "Dunkelsicht", 10, false, true},
      {7, 1, "Eisenaffine Aura", 15, false, true},
      {8, 1, "Entfernungssinn", 10, false, true},
      {9, 1, "Flink", 8, false, true},
      {10, 1, "Fuchssinn", 15, false, true},
      {11, 1, "Geborener Redner", 4, false, true},
      {12, 1, "Geweihter", 25, false, true},
      {13, 2, "Giftresistenz", 10, false, true},
      {14, 3, "Glück", 30, false, true},
      {15, 2, "Gutaussehend", 20, false, true},
      {16, 1, "Herausragende Fertigkeit", 2, true, false},
      {17, 1, "Herausragende Kampftechnik", 8, true, false},
      {18, 1, "Herausragender Sinn", 2, true, false},
      {19, 1, "Hitzeresistenz", 5, false, true},
      {20, 7, "Hohe Astralkraft", 6, false, true},
      {21, 7, "Hohe Karmalkraft", 6, false, true},
      {22, 7, "Hohe Lebenskraft", 6, false, true},
      {23, 1, "Hohe Seelenkraft", 25, false, true},
      {24, 1, "Hohe Zähigkeit", 25, false, true},
      {25, 1, "Immunität gegen (Gift)", 25, true, false},
      {26, 1, "Immunität gegen (Krankheit)", 25, true, false},
      {27, 1, "Kälteresistenz", 5, false, true},
      {28, 2, "Krankheitsresistenz", 10, false, true},
      {29, 1, "Magische Einstimmung", 40, true, false},
      {30, 1, "Mystiker", 20, false, true},
      {31, 1, "Nichtschläfer", 8, false, true},
      {32, 1, "Pragmatiker", 10, false, true},
      {33, 10, "Reich", 1, false, true},
      {34, 1, "Richtungssinn", 10, false, true},
      {35, 1, "Schlangenmensch", 6, false, true},
      {36, 1, "Schwer zu verzaubern", 15, false, true},
      {37, 1, "Soziale Anpassungsfähigkeit", 10, false, true},
      {38, 1, "Unscheinbar", 4, false, true},
      {39, 3, "Verbesserte Regeneration (Astralenergie)", 10, false, true},
      {40, 3, "Verbesserte Regeneration (Karmaenergie)", 10, false, true},
      {41, 3, "Verbesserte Regeneration (Lebensenergie)", 10, false, true},
      {42, 1, "Verhüllte Aura", 20, false, true},
      {43, 1, "Vertrauenerweckend", 25, false, true},
      {44, 1, "Waffenbegabung", 5, true, false},
      {45, 1, "Wohlklang", 5, false, true},
      {46, 1, "Zäher Hund", 20, false, true},
      {47, 1, "Zauberer", 25, false, true},
      {48, 1, "Zeitgefühl", 2, false, true},
      {49, 1, "Zweistimmiger Gesang", 5, false, true},
      {50, 1, "Zwergennase", 8, false, true}
    ])
  end
end
