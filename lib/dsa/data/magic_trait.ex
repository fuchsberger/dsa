defmodule Dsa.Data.MagicTrait do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset

  @table :magic_traits

  schema "magic_traits" do
    field :magic_trait_id, :integer
    field :details, :string
    field :ap, :integer
    belongs_to :character, Dsa.Accounts.Character
  end

  @fields ~w(magic_trait_id character_id ap)a
  def changeset(magic_trait, params \\ %{}) do
    magic_trait
    |> cast(params, [:details | @fields])
    |> validate_required(@fields)
    |> validate_length(:details, max: 50)
    |> validate_number(:ap, greater_than: 0)
    |> validate_number(:magic_trait_id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :magic_trait_id])
  end

  def count, do: 5
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
    <p class="small mb-1"><strong>Regel:</strong> <%= rule(id) %></p>
    <p class="small mb-0"><strong>Vorraussetzungen:</strong> <%= reqs(id) %></p>
    """
  end

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, ap, fixed_ap, details, desc, rule, reqs}
      {1, "Aura verbergen", 20, true, false, "Der Zauberkundige kann seine magische Aura so verhüllen, dass seine magische Befähigung durch Hellsichtzauber und andere magische Wahrnehmung erschwert oder gar nicht entdeckt werden kann.", "Hierzu ist eine erfolgreiche Probe auf das Talent Willenskraft nötig. Proben auf Liturgien oder Hellsichtzauber, die direkt auf den Zauberkundigen gewirkt werden, um ein magisches Potenzial zu erkennen, sind um QS der Probe auf Willenskraft erschwert. Vor ungerichteter magischer Wahrnehmung ist sein magisches Talent komplett verborgen. So lange der Zauberkundige seine Aura verhüllt, kann er weder zaubern, noch bereits gewirkte Zauber aufrechterhalten. Aura verbergen ist kombinierbar mit dem Vorteil Verhüllte Aura. Die Aktivierung der Sonderfertigkeit erfordert 1 Aktion und kann während des Wirkungszeitraums bewusst aus- und eingeschaltet werden. Dies erfordert ebenfalls 1 Aktion. Durch Ausschalten erleidet der Anwender jedes Mal eine Stufe Verwirrung. Der Wirkungszeitraum endet, bis der Zauberer die verborgene Aura freiwillig
      aufgibt, er schläft oder den Status Bewusstlos erhält.", "MU 13, IN 13"},
      {2, "Merkmalskenntnis", 10, false, true, "Die Kenntnis eines Merkmals umfasst das tiefere Verständnis einer bestimmten Ausprägung der Magie.","Nur mit dem Erwerb einer bestimmten Merkmalskenntnis ist es dem Zauberkundigen möglich, Zauber über einen Fertigkeitswert von 14 hinaus zu steigern. Außerdem kann der Zauberkundige jetzt auch Zauber einer fremden Tradition mit dem entsprechenden Merkmal modifizieren. Der Zauberkundige muss zum Erlernen einer Merkmalskenntnis drei Zauber des gewünschten Merkmals auf 10 beherrschen und sich eingehend mit den Besonderheiten des Merkmals beschäftigt haben, beispielsweise durch einige Jahre Forschung an einer Magierakademie, in der speziell dieses Merkmal gelehrt wird, oder durch andere in diesem Merkmal erfahrene Lehrmeister.
      Nachdem das Merkmal erworben wurde, gibt es für Zauber mit diesem Merkmal keine weitere spezielle Grenze (außer die der normalen Höchstwerte für Fertigkeiten).", "Leiteigenschaft der Tradition 15, 3 Zauber des Merkmals auf 10"},
      {3, "Starke Zaubertricks", 2, true, false, "Die Zaubertricks des Helden sind besonders stark.", "Zaubertricks gelten als mit 2 QS bestanden.", "Vorteil Zauberer"},
      {4, "Verbotene Pforten", 10, true, false, "Der Zauberkundige kann seine Lebensenergie als Ersatz für Astralenergie verwenden.", "Ein Zauberer kann Anstelle von AsP auch LeP
      für die Zauberkosten aufwenden. Es muss jedoch pro Zauber mindestens 1 AsP aufgewendet werden. Dies ist ausgesprochen schmerzhaft und erfordert daher eine Probe auf das Talent Selbstbeherrschung. Misslingt diese, misslingt auch der Zauber. Der Zauberkundige muss dann wie sonst die Hälfte der Kosten aufbringen, wobei diese zuerst von den AsP und, sollten diese nicht ausreichen, dann von seinen
      LE abgezogen werden.", "MU 12"},
      {5, "Zauberzeichen", 20, true, false, "Um Bann- und Schutzkreise und Zauberglyphen erlernen
      und korrekt zeichnen zu können, benötigt man diese Sonderfertigkeit.", "Der Held verfügt durch diese Sonderfertigkeit im Talent Malen & Zeichnen über das neue Anwendungsgebiet Zauberzeichen malen.", "FF 12"}
    ])
  end
end
