defmodule Dsa.Data.FateTrait do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @table :fait_traits

  @primary_key false
  schema "fate_traits" do
    field :fate_trait_id, :integer, primary_key: true
    belongs_to :character, Dsa.Characters.Character, primary_key: true
  end

  @fields ~w(fate_trait_id character_id)a
  def changeset(fate_trait, params \\ %{}) do
    fate_trait
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:fate_trait_id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :fate_trait_id])
  end

  def count, do: :ets.info(@table, :size)
  def list, do: :ets.tab2list(@table)

  def options(changeset) do
    traits = get_field(changeset, :fate_traits)
    list()
    |> Enum.map(fn {id, name, _ap, _desc, _rule} -> {name, id} end)
    |> Enum.reject(fn {_name, id} -> Enum.member?(Enum.map(traits, & &1.fate_trait_id), id) end)
  end

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def ap(id), do: :ets.lookup_element(@table, id, 3)
  def desc(id), do: :ets.lookup_element(@table, id, 4)
  def rule(id), do: :ets.lookup_element(@table, id, 5)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, ap, desc, rule}
      {1, "Attacke verbessern", 5, "Einige Helden verfügen über ein besonderes Quäntchen Glück im Nahkampf.", "Mittels dieser Sonderfertigkeit kann der Held Schicksalspunkte für Ergebnis verbessern (Attacke) einsetzen."},
      {2, "Ausweichen verbessern", 5, "Der Held kann durch diese Sonderfertigkeit im Notfall einem gefährlichen Angriff ausweichen.", "Mittels dieser Sonderfertigkeit kann der Held Schicksalspunkte für Ergebnis verbessern (Ausweichen) einsetzen."},
      {3, "Eigenschaft verbessern", 5, "Eine Eigenschaftsprobe kann durch Glück doch noch gelingen. Der Einsatz ist auch innerhalb einer Teilprobe bei einer Fertigkeitsprobe gestattet, jedoch verbessert sich nur das Ergebnis einer Teilprobe, egal wie oft die Eigenschaft bei der Fertigkeitsprobe vorkommt.", "Mittels dieser Sonderfertigkeit kann der Held Schicksalspunkte für Ergebnis verbessern (Eigenschaft) einsetzen."},
      {4, "Fernkampf verbessern", 5, "Einige Helden verfügen über ein besonderes Quäntchen Glück im Fernkampf.", "Mittels dieser Sonderfertigkeit kann der Held Schicksalspunkte für Ergebnis verbessern (Fernkampf) einsetzen."},
      {5, "Parade verbessern", 5, "Durch diese Sonderfertigkeit kann der Held eine misslungene Parade eventuell doch noch bestehen.", "Mittels dieser Sonderfertigkeit kann der Held Schicksalspunkte für Ergebnis verbessern (Parade) einsetzen."},
      {6, "Wachsamkeit verbessern", 10, "Ein Charakter mit Wachsamkeit spürt eine für ihn
      gefährliche Situation, kurz bevor sie eintritt. Dies kann zum Beispiel ein Tierangriff oder der Hinterhalt einer Räuberbande sein.", "Erleidet ein Held den Status Überrascht, kann er einen Schip ausgeben, um den Status sofort aufzuheben."},
    ])
  end
end
