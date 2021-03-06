defmodule Dsa.Data.Blessing do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset
  alias Dsa.Type.Probe

  import DsaWeb.DsaHelpers, only: [traits: 0]

  @table :blessings
  @sf_values ~w(A B C D E)a

  schema "blessings" do
    field :ceremony, :boolean, default: false
    field :name, :string
    field :sf, Ecto.Enum, values: @sf_values

    field :cost, :integer
    field :cast_time, :integer

    field :probe, Probe
    field :t1, Ecto.Enum, values: traits(), virtual: true
    field :t2, Ecto.Enum, values: traits(), virtual: true
    field :t3, Ecto.Enum, values: traits(), virtual: true
  end

  @fields ~w(id sf t1 t2 t3 ceremony cast_time cost name)a
  def changeset(blessing, params \\ %{}) do
    blessing
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:t1, traits())
    |> validate_inclusion(:t2, traits())
    |> validate_inclusion(:t3, traits())
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

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, desc, range, duration, target}
      {1, "Eidsegen", "Der Geweihte lässt jemanden einen Eid ablegen. Der Gesegnete empfindet den Eid als bindend und kann sich diesem nur durch eine Probe entziehen. Der Eidsprechende muss den Eid freiwillig leisten. Der Eid kann nur durch eine Probe auf Willenskraft erschwert um 1 gebrochen werden.", "4 Schritt", "1 Jahr", "Kulturschaffende"},
      {2, "Feuersegen", "Auf der Handfläche oder dem Zeigefinger des Geweihten entsteht eine kleine Flamme, die einen Raum erhellt oder ausreicht, um eine Kerze zu entzünden. Der Geweihte kann durch die Flamme nicht verletzt werden (wohl aber durch Flammen, die durch den Feuersegen entzündet werden). Die Helligkeit der Flamme entspricht einer gewöhnlichen Kerze normaler Machart.", "selbst", "5 Minuten", "Kulturschaffende"},
      {3, "Geburtssegen", "Ein Neugeborenes wird gesegnet und in die Gemeinschaft der Gläubigen aufgenommen. Es ist bis zum Ende der Wirkungsdauer vor dem Raub durch Kobolde, Feen und niedere Dämonen geschützt. Diese Segnung kann nur bis maximal 12 Tage nach der Geburt eingesetzt werden, danach wirkt sie nicht mehr auf das Neugeborene.", "Berührung", "in Zwölfgötterkirchen bis zum 12. Lebensjahr", "Kulturschaffende"},
      {4, "Glückssegen", "Der Gesegnete hat einmal während der Wirkungsdauer der Segnung ein Fünkchen Glück. Er kann nach dem Ablegen einer Fertigkeitsprobe 1 FP hinzuaddieren, um z.B. eine höhere Qualitätsstufe zu erreichen.", "Berührung", "12 Stunden", "Kulturschaffende"},
      {5, "Grabsegen", "Das Grab eines Verstorbenen wird gesegnet. Um die Leiche auszugraben und das Grab zu entweihen, muss dem Grabräuber eine Probe auf Willenskraft (Bedrohungen standhalten) erschwert um 1 gelingen. Bei Misslingen verspürt er ein Unwohlsein, das ihn von
      der Grabschändung zurückhält. Nekromantische Zauber auf die Leiche sind um 1 erschwert, so lange der Körper sich im gesegneten Grab befindet.", "Berührung", "12 Monate", "Zone"},
      {6, "Harmoniesegen", "Wer durch einen Harmoniesegen gesegnet wurde, der erfreut sich einen ganzen Tag lang positiver Gefühle. Alle Effekte, die Furcht auslösen, erhalten eine Erschwernis von 1.", "Berührung", "12 Stunden", "Kulturschaffende"},
      {7, "Kleiner Heilsegen", "Der Gesegnete erhält 1 Lebenspunkt zurück. Die Person kann nur einmal pro Tag von dieser Segnung profitieren.", "Berührung", "sofort", "Kulturschaffende"},
      {8, "Kleiner Schutzsegen", "Der Schutzsegen kann einige als unheilig geltende Wesen fernhalten. Folgende Typen von Wesen können aufgehalten werden: Untote (Hirnlose) und Dämonen (niedere Dämonen). Bei Errichtung des kleinen Schutzsegens muss entschieden werden, welcher von beiden Typen aufgehalten  wird. Das Wesen kann während der Wirkungsdauer das gesegnete Gebiet nicht betreten. Ist das Wesen gezwungen, das Gebiet zu betreten, dann versucht es sofort, sich wieder aus der Zone zurückzuziehen. Der Kleine Schutzsegen darf nicht größer sein als 4 Schritt Radius, sehr wohl aber kleiner. Die Zone ist stationär und bewegt sich nicht mit dem Geweihten. Wenn sich Personen innerhalb der Zone an den Rand der Zone bewegen, um dort lauernde Wesen im Nahkampf anzugreifen, können die Wesen ebenfalls angreifen.", "4 Schritt", "4 Kampfrunden", "Zone"},
      {9, "Speisesegen", "Das gesegnete Essen ist wohlschmeckend und nahrhaft. Gifte bis Stufe 2 und Verunreinigungen werden in der Speise neutralisiert. Die Segnung reicht für eine Portion.", "Berührung", "sofort", "Objekt"},
      {10, "Stärkungssegen", "Der Gesegnete verspürt keine Mattigkeit und Erschöpfung mehr. Er kann bei einer Probe auf Selbstbeherrschung einen Würfel neu würfeln (wie unter dem Einsatz des Vorteils Begabung). Pro Tag kann nur ein Stärkungssegen auf eine Person angewandt werden. Nachdem die Segnung genutzt wurde, ist sie verbraucht.", "selbst", "12 Kampfrunden", "Kulturschaffende"},
      {11, "Tranksegen", "Wer von dem gesegneten Getränk trinkt, fühlt sich erfrischt. Gifte bis Stufe 2 und Verunreinigungen werden im Getränk neutralisiert. Die Segnung reicht für einen Liter.", "Berührung", "sofort", "Objekt"},
      {12, "Weisheitssegen", "Der Gesegnete wird von Weisheit erfüllt. Er kann die Lösung eines Problems besser erfassen und bei einer Probe auf ein Wissenstalent einen Würfel neu würfeln(wie unter dem Einsatz des Vorteils Begabung). Pro Tag kann nur ein Weisheitssegen auf eine Person angewandt werden. Nachdem die Segnung genutzt wurde, ist sie verbraucht.", "Berührung", "12 Stunden", "Kulturschaffende"}
    ])
  end
end
