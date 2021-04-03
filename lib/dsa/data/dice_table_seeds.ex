defmodule Dsa.Data.DiceTableSeeds do
  alias Dsa.Data

  @entries %{
    "Nahkampf-Patzertabelle" => [
      [
        "2 Waffe zerstört",
        "Die Waffe ist unwiederbringlich zerstört. Bei unzerstörbaren Waffen wird das Ergebnis wie bei 5 behandelt."
      ],
      [
        "3 Waffe schwer beschädigt",
        "Die Waffe ist nicht mehr verwendbar, bis sie repariert wird. Bei unzerstörbaren Waf fen wird das Ergebnis wie bei 5 behandelt."
      ],
      [
        "4 Waffe beschädigt",
        "Die Waffe ist beschädigt worden. Alle Proben auf Attacke und Parade sind um 2 erschwert, bis sie repariert wird. Bei unzerstörbaren Waffen wird das Ergebnis wie bei 5 behandelt."
      ],
      ["5 Waffe verloren", "Die Waffe ist zu Boden gefallen."],
      [
        "6 Waffe stecken geblieben",
        "Die Waffe des Helden ist in einem Baum, einer Holzwand, dem Boden oder Ähnlichem stecken geblieben. Um sie zu befreien, ist 1 Aktion und eine um 1 erschwerte Probe auf Kraftakt (Ziehen & Zerren) notwendig."
      ],
      [
        "7 Sturz",
        "Der Held stolpert und stürzt, wenn sei nem Spieler nicht eine um 2 erschwerte Probe auf Körperbeherrschung (Balance) gelingt. Sollte er das nicht schaffen, erhält der Held den Status Liegend."
      ],
      ["8 Stolpern", "Der Held stolpert, seine nächste Handlung ist um 2 erschwert."],
      ["9 Fuß verdreht", "Der Held erhält für 3 Kampfrunden eine Stufe Schmerz."],
      [
        "10 Beule",
        "Der Held hat sich im Eifer des Gefechts den Kopf gestoßen. Er erhält für eine Stunde eine Stufe Betäubung."
      ],
      [
        "11 Selbst verletzt",
        "Der Held hat sich selbst verletzt und er leidet Schaden. Der Schaden seiner Waffe wird unter Einbeziehung des Schadens bonus ausgewürfelt. Bei unbewaffneten Kämpfern wird 1W6 TP angenommen."
      ],
      [
        "12 Selbst schwer verletzt",
        "Ein schwerer Eigentreffer des Helden. Der Schaden seiner Waffe wird unter Einbeziehung des Schadensbonus ausgewürfelt und dann verdoppelt. Bei unbewaffneten Kämpfern wird 1W6 TP angenommen."
      ]
    ],
    "Fernkampf-Patzertabelle" => [
      [
        "2 Waffe zerstört",
        "Die Waffe ist unwiederbringlich zerstört. Bei unzerstörbaren Waffen wird das Ergebnis wie bei 5 behandelt."
      ],
      [
        "3 Waffe schwer beschädigt",
        "Die Waffe ist nicht mehr einsetzbar, bis sie repariert wird. Bei unzerstörbaren Waffen wird das Ergebnis wie bei 5 behandelt."
      ],
      [
        "4 Waffe beschädigt",
        "Die Waffe ist beschädigt worden. Alle Proben auf Fernkampf sind um 4 erschwert, bis sie repariert wird. Bei unzerstörbaren Waffen wird das Ergebnis wie bei 5 behandelt."
      ],
      ["5 Waffe verloren", "Die Waffe ist zu Boden gefallen."],
      [
        "6 Kamerad/ Unschuldiger getroffen",
        "Das Geschoss trifft aus Versehen einen Freund oder einen am Kampf Unbeteiligten. Ist kein solches Ziel in der Nähe, wird diese Auswirkung wie 11 Selbst verletzt behandelt. Der Schaden der Waffe wird unter Einbeziehung des Schadensbonus ausgewürfelt."
      ],
      [
        "7 Fehlschuss",
        "Der spektakuläre Fehlschuss trifft ein Objekt (Ladenschild heruntergeschossen, Glasfenster zu Bruch gegangen etc.)."
      ],
      [
        "8 Zerrung",
        "Der Held hat Rückenschmerzen und erleidet für die nächsten 3 Kampfrunden eine Stufe Schmerz."
      ],
      [
        "9 Sehne herausgerutscht/ Waffe nicht richtig gegriffen/Ladehemmung",
        "Der Held benötigt 2 komplette Kampfrunden, um die Waffe wieder einsatzbereit zu machen."
      ],
      [
        "10 Zu konzentriert",
        "Der Held ist mit Zielen oder mit seiner Waffe beschäftigt. Bis zu seiner nächsten Aktion kann er keine Verteidigungen ausführen."
      ],
      [
        "11 Selbst verletzt",
        "Der Held hat sich selbst verletzt und erleidet Schaden. Der Schaden der Waffe wird unter Einbeziehung des Schadensbonus ausgewürfelt."
      ],
      [
        "12 Schwer verletzt",
        "Ein schwerer Eigentreffer. Der Schaden der Waffe wird unter Einbeziehung des Schadensbonus ausgewürfelt und dann verdoppelt."
      ]
    ]
  }

  def seed do
    for {table_name, entries} <- @entries do
      {:ok, table} = Dsa.DiceTables.create_dice_table(%{table_name: table_name})

      IO.inspect(table)

      for entry <- entries do
        [result, description] = entry

       IO.inspect(entry)

        {:ok, _ } =
          Dsa.DiceTableEntries.create_dice_table_entry(
            %{"result" => result, "description" => description},
            table.id
          )
      end
    end
  end

  def reseed do
  end
end
