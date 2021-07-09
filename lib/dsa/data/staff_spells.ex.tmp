defmodule Dsa.Data.StaffSpell do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset

  @table :staff_spells

  @primary_key false
  schema "staff_spells" do
    field :id, :integer, primary_key: true
    field :details, :string
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  @fields ~w(id character_id)a
  def changeset(staff_spell, params \\ %{}) do
    staff_spell
    |> cast(params, [:details | @fields])
    |> validate_required(@fields)
    |> validate_length(:details, max: 50)
    |> validate_number(:id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :id])
  end

  def count, do: 8
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(c) do
    character_staff_spell_ids = Enum.map(c.staff_spells, & &1.id)

    1..count()
    |> Enum.reject(& Enum.member?(character_staff_spell_ids, &1))
    |> Enum.map(& {name(&1), &1})
  end

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def ap(id), do: :ets.lookup_element(@table, id, 3)
  def volumne(id), do: :ets.lookup_element(@table, id, 4)
  def ae(id), do: :ets.lookup_element(@table, id, 5)
  def effect(id), do: :ets.lookup_element(@table, id, 6)
  def reqs(id), do: :ets.lookup_element(@table, id, 7)
  def type(id), do: :ets.lookup_element(@table, id, 8)
  def details(id), do: :ets.lookup_element(@table, id, 9)

  def tooltip(id) do
    ~E"""
    <p class="small mb-1"><%= effect(id) %></p>
    <p class="small mb-1"><strong>Vorraussetzungen:</strong> <%= reqs(id) %></p>
    <p class="small mb-1"><strong>Volumen:</strong> <%= volumne(id) %></p>
    <p class="small mb-1"><strong>Asp-Kosten:</strong> <%= ae(id) %></p>
    <p class="small mb-0"><strong>Merkmal:</strong> <%= type(id) %></p>
    """
  end

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, ap, volumne, ae, effect, reqs, type, details}
      {1, "Bindung des Stabes", 10, 0, 0, "Die Bindung des Stabes ist der erste Stabzauber, der auf einen Magierstab gewirkt wird. Mit ihm wird der Stab an den Magier gebunden. Zudem wird er unzerbrechlich, auch wenn er die Flexibilität des Holzes bewahrt. Einzig elementares Feuer, das heißer brennt als ein Drachenodem oder ein IGNIFAXIUS, oder aber gezielte Antimagie können ihn zerstören. Der Stab gilt von nun an als magische Waffe und kann nicht durch andere Mittel wie den ARCANOVI mit weiteren Zaubern belegt werden. Ein Magier kann immer nur einen Magierstab besitzen. Das Binden eines Stabes kostet den Magier einmalig 2 permanente AsP. Der Magier kann sich entscheiden, seine Verbindung zum Stab zu lösen, beispielsweise um einen neuen Stab an sich zu binden. Nach dem Tod eines Magiers verliert der Stab nach 24 Stunden die permanent gespeicherten AsP und jegliche Magie. Bindungskosten: 2 permanente AsP", "keine", "Objekt", false},
      {2, "Doppeltes Maß", 5, 2, 1, "Der Stab kann auf seine doppelte Länge verlängert werden, ohne dass er merklich an Dicke einbüßt. Die Wirkung hält an, solange der Magier Körperkontakt mit dem Stab hält. Ein mittlerer Stab wird so lang, dass er unter Stangenwaffen fällt und die Reichweite lang erhält, der lange Stab wird so lang, dass er als Waffe nicht mehr zu benutzen ist. Ein kurzer Stab erhält die Reichweite mittel.", "keine", "Objekt", false},
      {3, "Ewige Flamme", 10, 2, 1, "Das Ende des Stabes kann nun willentlich entzündet werden und brennt wie eine Fackel. Das Feuer hat die natürliche Helligkeit und Hitze einer solchen Flamme, zehrt den Stab jedoch nicht auf. Im Kampf eingesetzt bietet die ewige Flamme keinen besonderen Vorteil. Die Wirkung des Stabzaubers endet automatisch, wenn der Magier schläft, den Status Bewusstlos erleidet oder spätestens nach 1 Stunde.", "keine", "Elementar", false},
      {4, "Flammenschwert", 35, 7, 3, "Mit diesem Stabzauber kann der Magier seinen Stab in ein heiß brennendes Flammenschwert oder, je nach Region, in einen Flammensäbel verwandeln. Dieses Flammenschwert gilt als magische Waffe und richtet wie jedes Feuer zusätzlichen Schaden an Wesen an, die feuerempfindlich sind. Es verursacht 1W6+7 Trefferpunkte. Der Stab muss eine Mindestlänge von einem Schritt besitzen, um in ein Flammenschwert verzaubert werden zu können. Die übrigen Werte entsprechen denen eines Langschwertes. Der Magier kann das Schwert auf zwei Varianten einsetzen: 1. Er kann es wie ein normales Schwert mit der Kampftechnik Schwerter führen. Bei einem Patzer verwandelt sich das Flammenschwert zurück in den Stab. Pro Kampfrunde kostet diese Variante nach der Aktivierung 1 AsP. 2. Er kann es per Telekinese fliegen und kämpfen lassen. Hierbei werden die Kampftechnik Schwerter und der entsprechende Attackewert des Magiers für Attacken verwendet. Es bewegt sich mit Geschwindigkeit 8. Der Magier muss sich zur Kontrolle des Schwertes konzentrieren. Das Flammenschwert kontrolliert fliegen zu lassen, ist eine länger dauernde Handlung (siehe Seite 228). Wenn sich das Schwert weiter als 32 Schritt weg vom Magier bewegt, bricht der Stabzauber ab und das Schwert verwandelt sich wieder zurück. Pro Kampfrunde kostet diese Variante nach der Aktivierung 2 AsP. Um ein fliegendes Flammenschwert festzuhalten, ist ein erfolgreicher Angriff mit Raufen und der Sonderfertigkeit Haltegriff nötig. Für diese Zwecke verfügt das Schwert über eine PA in Höhe der Hälfte der AT und einen Wert in Kraftakt von 10 Punkten mit Eigenschaften von 14 für die Probe.", "Ewige Flamme und Kraftfokus", "Elementar", false},
      {5, "Kraftfokus", 30, 6, 0, "Solange der Magier den Stab berührt, spart er bei jedem Zauber 1 AsP ein. Dieser Abzug wird nach Berechnung aller anderen Modifikationen eingerechnet. Die Ersparnis kann nicht dazu führen, dass die Kosten unter 1 AsP fallen. Solange der Stab in ein Flammenschwert, eine Fackel oder etwas anderes verwandelt ist, gilt die Ersparnis nicht. Der Magier muss den Stab in der Hand halten, wenn er von dem Stabzauber profitieren will.", "keine", "Objekt", false},
      {6, "Merkmalsfokus", 35, 8, 0, "Bei diesem Stabzauber muss ein Merkmal gewählt werden, das der Fokus unterstützen soll. Proben auf Zauber mit dem so unterstützten Merkmal sind um 1 erleichtert. Der Merkmalsfokus kann mehrfach mit unterschiedlichen Merkmalen auf den Stab gewirkt werden. Solange der Stab in ein  Flammenschwert, eine Fackel oder etwas anderes verwandelt ist, gilt dieser Vorteil nicht. Der Magier muss den Stab in der Hand halten, wenn er von dem Stabzauber profitieren will.", "Kraftfokus, passende Merkmalskenntnis", "je nach Merkmal", true},
      {7, "Seil des Adepten", 10, 2, 1, "Der Stab kann in ein unzerstörbares Seil von 10 Metern Länge verwandelt werden. Es kann sich um Objekte schlingen, wenn es geworfen wird. Knoten können so willentlich gebunden oder gelöst werden, solange der Magier das Seil berührt. Das Knoten und Entknoten zählt jeweils als 1 Aktion. Personen lassen sich damit nicht fesseln,
      außer sie haben den Status Bewegungsunfähig. Verliert der Magier den Kontakt zum Seil, verwandelt es sich zurück in seine ursprüngliche Stabform.", "keine", "Objekt", false},
      {8, "Stab-Apport", 15, 3, 1, "Der Stab kann vom Magier zu sich gerufen werden. Er fliegt auf dem kürzesten Weg mit Geschwindigkeit 15 zum Magier und umfliegt selbstständig
      Hindernisse. Fenster durchschlägt der Stab, Wände aus Holz oder Stein halten ihn jedoch auf. Der Magier muss für den Einsatz des Stab-Apports seinen Magierstab nicht sehen.", "keine", "Telekinese", false}
    ])
  end
end
