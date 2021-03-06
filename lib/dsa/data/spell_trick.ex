defmodule Dsa.Data.SpellTrick do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset

  @table :spell_tricks

  @primary_key false
  schema "spell_tricks" do
    field :id, :integer, primary_key: true
    belongs_to :character, Dsa.Characters.Character, primary_key: true
  end

  @fields ~w(id character_id)a
  def changeset(spell_trick, params \\ %{}) do
    spell_trick
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :id])
  end

  def count, do: 12
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(c) do
    character_spell_trick_ids = Enum.map(c.spell_tricks, & &1.id)

    1..count()
    |> Enum.reject(& Enum.member?(character_spell_trick_ids, &1))
    |> Enum.map(& {name(&1), &1})
  end

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def desc(id), do: :ets.lookup_element(@table, id, 3)
  def range(id), do: :ets.lookup_element(@table, id, 4)
  def duration(id), do: :ets.lookup_element(@table, id, 5)
  def target(id), do: :ets.lookup_element(@table, id, 6)
  def type(id), do: :ets.lookup_element(@table, id, 7)

  def tooltip(id) do
    ~E"""
    <p class="small mb-1"><%= desc(id) %></p>
    <p class="small mb-1"><strong>Reichweite:</strong> <%= range(id) %></p>
    <p class="small mb-1"><strong>Wirkungsdauer:</strong> <%= duration(id) %></p>
    <p class="small mb-1"><strong>Zielkategorie:</strong> <%= target(id) %></p>
    <p class="small mb-0"><strong>Merkmal:</strong> <%= type(id) %></p>
    """
  end

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, desc, range, duration, target, type}
      {1, "Abkühlung", "Der Zauberer senkt die Temperatur einer kleinen Menge Flüssigkeit maximal ein Becher voll) um bis zu 10 Grad.", "Berührung", "sofort", "Objekt", "Elementar"},
      {2, "Bauchreden", "Ein einzelnes Wort oder ein anderes kurzes, nicht allzu lautes Geräusch nach Wahl erklingt bis zu 8 Schritt entfernt vom Zaubernden.", "8 Schritt", "1 Aktion", "Zone", "Illusion"},
      {3, "Duft", "Der Zauberer riecht für etwa 5 Minuten nach einem Parfüm oder einem anderen für ihn angenehmen Geruch.", "selbst", "5 Minuten", "Kulturschaffende", "Illusion"},
      {4, "Feuerfinger", "Eine kleine Flamme entsteht etwa einen Zentimeter über einem Finger des Zaubernden. Sie brennt bis zu 5 Minuten. Der Zaubertrick schützt die Hand nicht vor der Hitze der Flamme.", "selbst", "5 Minuten", "Kulturschaffende", "Elementar"},
      {5, "Glücksgriff", "Der Zaubernde kann aus einer überschaubaren Menge Objekte gezielt das gewünschte herausgreifen. Er kann aus einem Kartenstapel eine bestimmte Karte ziehen,
      aus einem Beutel eine gewünschte Münze oder von einem Schlüsselbund den richtigen Schlüssel. Er muss dazu das gewünschte Objekt kennen und dieses muss auch wirklich an dem Ort vorhanden sein.", "selbst", "sofort", "Objekt", "Hellsicht"},
      {6, "Handwärmer", "Dieser Zaubertrick hält die Temperatur eines maximal faustgroßen Objektes konstant, so lange es in der Hand gehalten wird, maximal jedoch 5 Minuten.", "Berührung", "5 Minuten", "Objekt", "Elementar"},
      {7, "Lockruf", "Ein kleines Tier (Eichhörnchen, Taube) kommt neugierig auf den Zaubernden zu. Die Wirkung hält 5 Minuten an.", "4 Schritt", "5 Minuten", "Tiere", "Einfluss"},
      {8, "Regenbogenaugen", "Die Augenfarbe des Zaubernden ändert sich für 5 Minuten. Es sind unnatürliche Farben möglich.", "selbst", "5 Minuten", "Kulturschaffende", "Illusion"},
      {9, "Schlangenhände", "Die Hand- und Fingerknochen des Zaubernden werden sehr flexibel, sodass sie durch enge Öffnungen gezwängt werden können. Die Wirkung hält 5 Minuten an.", "selbst", "5 Minuten", "Kulturschaffende", "Verwandlung"},
      {10, "Schnipsen", "Eine kurze telekinetische Entladung mit einer Reichweite von 4 Schritt, die beispielsweise eine Münze von einem Tisch fegen kann. Sie ist nicht stark genug, um eine Glasflasche zu zerbrechen, genügt aber für eine Ohrfeige.", "4 Schritt", "sofort", "Objekt und Wesen", "Telekinese"},
      {11, "Signatur", "Auf einem leblosen Objekt nach Wahl des Zaubernden erscheint eine Glyphe oder ein Symbol und verbleibt dauerhaft. Der Zaubernde muss das Objekt berühren. Das Symbol wirkt wie gemalt und kann weggeputzt werden. Mittels dieses Tricks kann man jeweils nur eine Art von Zeichen auftauchen lassen (z.B. ein Piktogramm).", "Berührung", "sofort", "Objekt", "Objekt"},
      {12, "Trocken", "Der Zaubernde und seine Kleidung sind etwa 5 Minuten vor Nässe, beispielsweise durch Regen oder Schnee, geschützt. Nasse Kleidung wird durch den Trick nicht wieder trocken.", "selbst", "5 Minuten", "Objekt und Kulturschaffende", "Elementar"}
    ])
  end
end
