defmodule Dsa.Data.KarmalTrait do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset

  @table :karmal_traits

  schema "karmal_traits" do
    field :karmal_trait_id, :integer
    field :details, :string
    field :ap, :integer
    belongs_to :character, Dsa.Characters.Character
  end

  @fields ~w(karmal_trait_id character_id ap)a
  def changeset(karmal_trait, params \\ %{}) do
    karmal_trait
    |> cast(params, [:details | @fields])
    |> validate_required(@fields)
    |> validate_length(:details, max: 50)
    |> validate_number(:ap, greater_than: 0)
    |> validate_number(:karmal_trait_id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :karmal_trait_id])
  end

  def count, do: 4
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options do
    Enum.map(list(), fn {id, name, _ap, _fixed_ap, _details, _desc, _rule, _reqs} -> {name, id} end)
  end

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def ap(id), do: :ets.lookup_element(@table, id, 3)
  def fixed_ap(id), do: :ets.lookup_element(@table, id, 4)
  def details(id), do: :ets.lookup_element(@table, id, 5)
  def desc(id), do: :ets.lookup_element(@table, id, 6)
  def rule(id), do: :ets.lookup_element(@table, id, 7)
  def reqs(id), do: :ets.lookup_element(@table, id, 8)

  def tooltip(id) do
    ~E"""
    <p class="small mb-1"><%= desc(id) %></p>
    <%= unless is_nil(rule(id)) do %>
      <p class="small mb-1"><strong>Regel:</strong> <%= rule(id) %></p>
    <% end %>
    <p class="small mb-0"><strong>Vorraussetzungen:</strong> <%= reqs(id) %></p>
    """
  end

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, ap, fixed_ap, details, desc, rule, reqs}
      {1, "Aspektkenntnis", 15, false, true, "Durch diese Sonderfertigkeit erlangt ein Geweihter besondere Kenntnisse in einem bestimmten Aspekt seiner Kirche. Neben den üblichen Aspekten der unterschiedlichen Kirchen gibt es auch noch die Aspektkenntnis (allgemein). Diese wirkt sich auf alle Liturgien aus, die als Aspekt den Eintrag „allgemein“ aufweisen.", "Erst durch eine Aspektkenntnis kann ein Geweihter eine Liturgie auf einen FW von über 14 steigern. Nachdem der Aspekt erworben wurde, gibt es für Liturgien mit diesem Aspekt keine weitere spezielle Grenze (außer die der normalen Höchstwerte für Fertigkeiten).", "Leiteigenschaft der Tradition 15, 3 Liturgien und Zeremonien des Aspekts auf 10"},
      {2, "Fokussierung", 8, true, false, "Wird der Held in seiner Konzentration beim Wirken
      von Liturgien oder Zeremonien gestört, sind die  nötigen Proben auf Selbstbeherrschung (Störungen ignorieren) durch diese Sonderfertigkeit um 1 erleichtert.", nil, "MU 13"},
      {3, "Stärke des Glaubens", 10, true, false, "Der Geweihte verharrt in einer Position, ruft seine Gottheit an und konzentriert sich. Niedere Dämonen können den Geweihten nicht berühren oder direkt angreifen, so lange er die Konzentration aufrechterhält und sich nicht bewegt.", nil, "MU 15"},
      {4, "Starke Segnungen", 2, true, false, "Die Segnungen des Helden sind besonders stark.", "Segnungen gelten als mit 2 QS bestanden", "Vorteil Geweihter"}
    ])
  end
end
