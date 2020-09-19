defmodule Dsa.Data.FateTrait do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset

  @table :fait_traits

  @primary_key false
  schema "fate_traits" do
    field :id, :integer, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  @fields ~w(id character_id)a
  def changeset(fate_trait, params \\ %{}) do
    fate_trait
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :id])
  end

  def count, do: 6
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(), do: Enum.map(list(), fn {id, name, _ap, _desc, _rule} -> {name, id} end)

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def ap(id), do: :ets.lookup_element(@table, id, 3)
  def desc(id), do: :ets.lookup_element(@table, id, 4)
  def rule(id), do: :ets.lookup_element(@table, id, 5)

  def tooltip(id) do
    ~E"""
    <p class="small mb-1"><%= desc(id) %></p>
    <p class="small mb-0"><strong>Regel:</strong> <%= rule(id) %></p>
    """
  end

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
