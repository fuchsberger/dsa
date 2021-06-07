defmodule Dsa.Data.Skill do
  use Dsa, :schema

  alias DsaWeb.Router.Helpers, as: Routes

  def format_algolia(skill) do
    %{
      objectID: "skill_#{skill.id}",
      name: skill.name,
      type: gettext("Talent"),
      path: Routes.page_path(DsaWeb.Endpoint, :index),
      # path: Routes.skill_path(Dsa.Endpoint, :show, skill.slug),
      description: skill.description,
      list_entries: skill.applications
    }
  end

  defp regions do
    [
      gettext("AlʼAnfanisches Imperium"),
      gettext("Albernia"),
      gettext("Almada"),
      gettext("Andergast"),
      gettext("Aranien"),
      gettext("Bergkönigreiche der Zwerge"),
      gettext("Bornland"),
      gettext("Garetien"),
      gettext("Gjalskerland"),
      gettext("Hoher Norden"),
      gettext("Horasreich"),
      gettext("Kalifat"),
      gettext("Kosch"),
      gettext("Maraskan"),
      gettext("Nordmarken"),
      gettext("Nostria"),
      gettext("Orkland"),
      gettext("Rommilyser Mark"),
      gettext("Salamandersteine & umliegende Gebiete der Elfen"),
      gettext("Schattenlande"),
      gettext("Südmeer & Waldinseln"),
      gettext("Svellttal"),
      gettext("Thorwal"),
      gettext("Tiefer Süden"),
      gettext("Tobrien"),
      gettext("Tulamidenlande"),
      gettext("Weiden"),
      gettext("Windhag"),
      gettext("Zyklopeninseln")
    ]
  end

  def seed do
    skills = [
      %{
        id: 1,
        name: gettext("Alchimie"),
        category: :crafting,
        check: {:mu, :kl, :ff},
        applications: [
          %{name: gettext("Alchimistische Gifte")},
          %{name: gettext("Elixiere")},
          %{name: gettext("Profane Alchimie")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Alchemistisches Labor"),
        quality: gettext("Der Trank weist eine bessere Qualität auf."),
        failed: gettext("Das Elixier ist misslungen oder eine Analyse hat kein Ergebnis gebracht."),
        success: gettext("Der Held weiß exakt, welches Elixier er vor sich hat, welche Stufe es besitzt und wie lange haltbar es ist."),
        botch: gettext("Das Elixier sorgt für einen unangenehmen Nebeneffekt."),
        improvement_cost: :c,
        description: gettext("Mit der alten Kunst der Alchimie lassen sich sowohl wundersame Tinkturen als auch profane Substanzen wie Seifen, Glas und Porzellan, Farben und Lacke analysieren und herstellen.\nZur Herstellung von Elixieren und Tränken benötigt der Alchimist meist aufwendig aufzutreibende Grundstoffe, das richtige Rezept und ein Labor. Viele Alchimisten werden argwöhnisch betrachtet, da man befürchtet, sie könnten bei ihren verrückten Experimenten ihre Werkstätten in Brand setzen und giftige Wolken oder bestialischen Gestank produzieren."),
        reference: {gettext("Basis Regelwerk"), 206},
        examples: [
          %{
            action: gettext("Alchimistische Erzeugnisse herstellen oder analysieren"),
            modifier: gettext("je nach Elixir")
          }
        ]
      }, %{
        id: 2,
        name: gettext("Bekehren & Überzeugen"),
        category: :social,
        check: {:mu, :kl, :ch},
        applications: [
          %{name: gettext("Diskussionsführung")},
          %{name: gettext("Einzelgespräch")},
          %{name: gettext("öffentliche Rede")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("Mehr Menschen lassen sich von dem Helden bekehren, oder der Bekehrte folgt seiner neuen Überzeugung länger."),
        failed: gettext("Das Opfer glaubt dem Prediger nicht."),
        success: gettext("Das Opfer der Überzeugungsversuche ist vollends überzeugt."),
        botch: gettext("Das Opfer fühlt sich vom Prediger beleidigt oder für dumm verkauft."),
        improvement_cost: :b,
        description: "Dieses Talent ist das Handwerkszeug eines jeden Geweihten, insbesondere von Priestern mit starkem Missionierungsdrang.\nEs erlaubt die Beeinflussungen von Menschen und hilft, sie von der Meinung oder den Standpunkten des Talentanwenders dauerhaft zu überzeugen.\nIm Einzelgespräch vermag ein Geweihter sich einerseits intensiv mit seinem Gegenüber zu beschäftigen, andererseits dessen Glauben infrage zu stellen und Zweifel zu säen, bis hin zu einer kompletten Gehirnwäsche. Jedoch ist das Talent nicht nur für Geweihte nützlich: Rhetorik wird von Politikern, Philosophen und anderen Rednern gerne als Stilmittel verwendet, um andere zu überzeugen, sich ihren Ideen zu verschreiben, ebenso von Demagogen und Freiheitskämpfern, die nicht selten versuchen, das gemeine Volk zu einem Aufstand aufzuwiegeln und gegen die Herrscherschicht aufzuhetzen.\nIm Gegensatz zu den Talenten [Überreden] und [Einschüchtern] ist [Bekehren & Überzeugen] ein Prozess, der die Geisteshaltung des Betroffenen längerfristig beeinflusst und nicht nur kurzzeitig ändert.",
        reference: {gettext("Basis Regelwerk"), 194},
        examples: [
          %{
            action: gettext("Den Dörfler in guten Zeiten von einer Spende überzeugen"),
            modifier: "+5"
          },
          %{
            action: gettext("Einem Goblin die Gemeinsamkeiten von Firun und seinem Gott nahe bringen"),
            modifier: "+3"
          },
          %{
            action: gettext("Einen Bauern überzeugen, zusätzliche Abgaben an wenig verehrte Götter zu leisten"),
            modifier: "+1"
          },
          %{
            action: gettext("Bei einer politischen Diskussion sein rhetorisches Können beweisen"),
            modifier: "+/- 0"
          },
          %{
            action: gettext("Eine wirkungsvolle Schmähschrift anfertigen"),
            modifier: "-1"
          },
          %{
            action: gettext("Eine Gruppe von Bauern gegen den örtlichen Baron aufhetzen"),
            modifier: "–3"
          },
          %{
            action: gettext("Einen Zwerg zum Efferdkult bekehren"),
            modifier: "-5"
          }
        ]
      }, %{
        id: 3,
        name: gettext("Betören"),
        category: :social,
        check: {:mu, :ch, :ch},
        applications: [
          %{name: gettext("Anbändeln")},
          %{name: gettext("Aufhübschen")},
          %{name: gettext("Liebeskünste")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: gettext("nein, situationsabhängige Ausnahmen können vorkommen, z.B. Verführen in Gestechrüstung"),
        tools: nil,
        quality: gettext("Der Bezirzte ist bereit, mehr für den Helden zu tun."),
        failed: gettext("Dem Helden gelingt es vorerst nicht, Interesse beim Opfer zu wecken."),
        success: gettext("Das Verführungsopfer versucht, dem betörenden Helden alle Wünsche zu erfüllen."),
        botch: gettext("Der Held kassiert eine schallende Ohrfeige für seinen plumpen Anmachversuch."),
        improvement_cost: :b,
        description: "Mit [Betören] kann ein Held versuchen, seine Ausstrahlung und Attraktivität einzusetzen, um sich jemand gewogen zu machen. Um sich durch Anbändeln einen Vorteil zu verschaffen, beispielsweise einen Gardisten dazu zu bringen, noch einmal ein Auge zu zudrücken, ist das Talent genau die richtige Wahl. Das bedeutet jedoch nicht, dass jeder Einsatz der Fähigkeit gleich eine Einladung zu einem Schäferstündchen sein muss.\nDennoch bildet das Talent ebenso die Kunst der Verführung ab und gibt Auskunft darüber, wie geschickt sich jemand in den Liebeskünsten anstellt. Wählt der Held schmeichelhafte Worte, schafft er eine angenehme Umgebung und geht auf die Vorlieben seines Gegenübers ein?\nUnter Betören fällt aber nicht nur das Anbändeln, sondern auch sich zu schminken und aufzuhübschen, um die Besucher eines Balls oder einer Taverne für sich zu begeistern.\nGegen Betörungsversuche kann sich ein Held mit dem Talent [Willenskraft (Betören widerstehen)] zur Wehr setzen.",
        reference: {gettext("Basis Regelwerk"), 195},
        examples: [
          %{
            action: "Ein kleines Fest im engen Freundeskreis gestalten",
            modifier: "+5"
          },
          %{
            action: "Den Liebsten um einen ungewöhnlichen Gefallen bitten",
            modifier: "+3"
          },
          %{
            action: "Ein Techtelmechtel mit einer leicht verführbaren Person anfangen",
            modifier: "+1"
          },
          %{
            action: "Dem Wirt schöne Augen machen, um einen Preisnachlass zu bekommen",
            modifier: "+/- 0"
          },
          %{
            action: "Erotische Briefe verfassen",
            modifier: "-1"
          },
          %{
            action: "Eine erinnerungswürdige Orgie inszenieren",
            modifier: "–3"
          },
          %{
            action: "Eine Zielperson verführen, die in einem enthaltsamen Umfeld aufwuchs",
            modifier: "-5"
          }
        ]
      }, %{
        id: 4,
        name: gettext("Boote & Schiffe"),
        category: :crafting,
        check: {:ff, :ge, :kk},
        applications: [
          %{name: gettext("Kampfmanöver")},
          %{name: gettext("Langstrecke")},
          %{name: gettext("Verfolgungsjagden")},
          %{name: gettext("Wettfahren")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Schiff oder Boot"),
        quality: gettext("Die Distanz bis zum Ziel kann schneller überwunden werden."),
        failed: gettext("Der Held kommt mit dem Boot oder Schiff kaum voran."),
        success: gettext("Der Held nutzt günstige Strömungen und Winde, um doppelt so schnell voranzukommen wie üblich."),
        botch: gettext("Der Held fällt von Bord oder ein wichtiger Teil des Wasserfahrzeugs wurde beschädigt."),
        improvement_cost: :b,
        description: "Wenn es darum geht, von der kleinsten Nussschale bis zur größten Kogge Flüsse, Seen und das weite Meer unsicher zu machen, ist man auf das Talent [Boote & Schiffe] angewiesen. Vom Rudern und Treideln über den richtigen Umgang mit der Takelage und kleinere Reparaturen bis zur Verwendung von Südweiser und Tiefenlot deckt das Talent alle wichtigen Tätigkeiten von Seeleuten ab.\nDas Steuern von Schiffen ist eine [komplexe] Angelegenheit und erfordert entsprechende Berufsgeheimnisse.",
        reference: {gettext("Basis Regelwerk"), 207},
        examples: [
          %{
            action: "Mit einem Floß den Fluss hinabfahren",
            modifier: "+5"
          },
          %{
            action: "Über einen ruhigen See rudern",
            modifier: "+3"
          },
          %{
            action: "Die Segel reffen",
            modifier: "+1"
          },
          %{
            action: "Unruhige Fahrt auf einem Fluss",
            modifier: "+/- 0"
          },
          %{
            action: "Riskantes Wendemanöver einleiten",
            modifier: "-1"
          },
          %{
            action: "Mit einer Galeere ein anderes Schiff rammen",
            modifier: "–3"
          },
          %{
            action: "Im Sturm Eisschollen ausweichen",
            modifier: "-5"
          }
        ]
      }, %{
        id: 5,
        name: gettext("Brett- & Glücksspiel"),
        category: :knowledge,
        check: {:kl, :kl, :in},
        applications: [
          %{name: gettext("Würfelspiele")},
          %{name: gettext("Brettspiele")},
          %{name: gettext("Kartenspiele")},
          %{name: gettext("Wettspiele")}
        ],
        uses: [ %{name: gettext("Cheating")}],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: gettext("Spiel"),
        quality: gettext("Der Held hat einen guten Spielzug gemacht."),
        failed: gettext("Der Held verliert."),
        success: gettext("Der Held gewinnt auf spektakuläre Art und Weise. Wurde um Geld gespielt, verdoppelt sich sein Gewinn."),
        botch: gettext("Der Held wird fälschlicherweise des Falschspiels verdächtigt oder hat eine Pechsträhne. Wird um Geld gespielt, verliert er mindestens den kompletten Einsatz (oder mehr)."),
        improvement_cost: :a,
        description: "Außer reiner Regelkunde deckt dieses Talent die Kenntnis von Spieltechnik, Strategien, Gewinnkombinationen und Wahrscheinlichkeiten bei verschiedenen Brett-, Karten- und Würfelspielen ab. Wenn man nicht gerade gegen sich selbst spielt, sind Vergleichsproben gegen das Talent [Brett- & Glücksspiel] der Mitspieler nötig.\n[Komplexere] Spiele müssen über ein Berufsgeheimnis erlernt werden.",
        reference: {gettext("Basis Regelwerk"), 201},
        examples: [
          %{
            action: "Held ist nicht abgelenkt und kann sich konzentrieren",
            modifier: "+1"
          },
          %{
            action: "Held ist leicht abgelenkt",
            modifier: "-1"
          },
          %{
            action: "Ein Spiel gewinnen",
            modifier: "Vergleichsprobe (Brett- & Glücksspiel [entsprechendes Anwendungsgebiet] gegen Brett- & Glücksspiel [entsprechendes Anwendungsgebiet])"
          }
        ]
      }, %{
        id: 6,
        name: gettext("Einschüchtern"),
        category: :social,
        check: {:mu, :in, :ch},
        applications: [
          %{name: gettext("Drohung")},
          %{name: gettext("Folter")},
          %{name: gettext("Provokation")},
          %{name: gettext("Verhör")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("Das Opfer ist länger eingeschüchtert oder verrät dem Helden mehr als erwartet."),
        failed: gettext("Das Gegenüber ignoriert alle Schmähungen und Einschüchterungsversuche des Helden."),
        success: gettext("Das Gegenüber des Helden ist vollkommen eingeschüchtert und wird in absehbarer Zeit nichts mehr gegen den Helden unternehmen."),
        botch: gettext("Anstatt eingeschüchtert oder beleidigt zu sein, geschieht das Gegenteil: Das Opfer ist wütend, völlig gelassen oder amüsiert. Oder der Held macht sich mit seinem Gehabe völlig zum Affen."),
        improvement_cost: :b,
        description: "Durch dieses Talent kann man sein Gegenüber bedrohen, beschimpfen oder beleidigen, um beispielsweise an Informationen zu gelangen oder jemandem Angst einzuflößen.\nEin Duellant kann versuchen, seinen Gegner zu provozieren, um seinen Jähzorn zu wecken. Der Ork-Häuptling mag nicht so stark sein, wie er aussieht, doch mit den richtigen Drohungen kann er seinen Kontrahenten beeindrucken, sodass er ihn erst gar nicht herausfordert. Mit Einschüchterungen kann man an Informationen gelangen, für die Überreden eine zu milde Form der Überzeugungskunst ist: Hier geht es zum Verhör.\nDie Folter (bei der Inquisition als hochnotpeinliche Befragung bekannt) hingegen ist nicht nur Androhung, sondern zudem Anwendung körperlicher Gewalt.",
        reference: {gettext("Basis Regelwerk"), 195},
        examples: [
          %{
            action: "Mit einer Barbarenstreitaxt ein Kind einschüchtern",
            modifier: "+5"
          },
          %{
            action: "Einen Jähzornigen mit Schmähungen zum Angriff provozieren",
            modifier: "+3"
          },
          %{
            action: "Einen eitlen Gecken beleidigen",
            modifier: "+1"
          },
          %{
            action: "Einem Bürger mit Waffengewalt erfolgreich drohen",
            modifier: "+/- 0"
          },
          %{
            action: "Einen Dieb mit Drohungen dazu bringen, sein Versteck zu verraten",
            modifier: "-1"
          },
          %{
            action: "Eine Patrouille der Stadtgarde einschüchtern",
            modifier: "–3"
          },
          %{
            action: "Einen Fanatiker vertreiben",
            modifier: "-5"
          }
        ]
      }, %{
        id: 7,
        name: gettext("Etikette"),
        category: :social,
        check: {:kl, :in, :ch},
        applications: [
          %{name: gettext("Benehmen")},
          %{name: gettext("Klatsch & Tratsch")},
          %{name: gettext("leichte Unterhaltung")},
          %{name: gettext("Mode")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("TDer Held hinterlässt einen guten Eindruck und bleibt positiv in Erinnerung."),
        failed: gettext("Der Held kann sich nicht an alle wichtigen Benimmregeln erinnern und fällt unangenehm auf."),
        success: gettext("Auf der Feier ist der Held aufgrund seines Benehmens, Wortwitzes und Charmes der Mittelpunkt."),
        botch: gettext("er Held beleidigt mit seinem Verhalten eine wichtige Persönlichkeit."),
        improvement_cost: :b,
        description: "Wird einem Abenteurer die Ehre zuteil, sich in der Gesellschaft wichtiger Würdenträger oder Adliger aufzuhalten, so ist gutes Benehmen Pflicht.\nEin Held, der sich am Hofe eines Grafen oder einer Sultana schlecht benimmt, kann sich schneller als er glaubt vor dem Burgtor oder gar im Verlies wiederfinden. Das Talent [Etikette] hilft ihm, die korrekte Anrede für den lokalen Herrscher zu wählen, er achtet bei einer erfolgreichen Probe auf die Einhaltung der örtlichen Sitten und zeigt sich am Esstisch von seiner besten Seite.\nEtikette umfasst ebenfalls das Wissen um die aktuelle Mode, sowie das grundlegende Benehmen gegenüber Höhergestellten. Was sind die aktuellen Gesprächsthemen am Hofe? Welche Witze gelten im Horasreich als modern? Wie kann man das Gegenüber so beleidigen, dass die Etikette gewahrt bleibt, aber jeder weiß, was gemeint ist? All dies wird mittels [Etikette] geregelt.",
        reference: {gettext("Basis Regelwerk"), 196},
        examples: [
          %{
            action: "Wie lautet die Anrede eines einfachen Geweihten?",
            modifier: "+5"
          },
          %{
            action: "Wie ist die korrekte Anrede der Tochter eines Junkers?",
            modifier: "+3"
          },
          %{
            action: "Muss man sich vor dem Baron verneigen?",
            modifier: "+1"
          },
          %{
            action: "Wie benehme ich mich vor Höhergestellten?",
            modifier: "+/- 0"
          },
          %{
            action: "Was trägt man beim Empfang der Sultana von Palmyrabad?",
            modifier: "-1"
          },
          %{
            action: "Welche Witze sind am Hof des Horas tabu?",
            modifier: "–3"
          },
          %{
            action: "Wie ist der Titel des Jagdmeisters des Emirats Floeszern – und wie grüßt
            man ihn?",
            modifier: "-5"
          }
        ]
      }, %{
        id: 8,
        name: gettext("Fährtensuchen"),
        category: :nature,
        check: {:mu, :in, :ge},
        applications: [
          %{name: gettext("Verwischen eigener Fährte")},
          %{name: gettext("humanoide Spuren")},
          %{name: gettext("tierische Spuren")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("Über die Qualitätsstufe kann der Held mehr Details in der Fährte erkennen."),
        failed: gettext("Der Held findet keine Spur oder kann keine neuen Erkenntnisse gewinnen."),
        success: gettext("Sofern die Spur nicht komplett zerstört wurde, kann der Held ihr zielsicher bis zum Ende folgen. Er erhält mehr Informationen als üblich. Täuschungsmanöver wie das Verwischen der Spuren durchschaut er sofort."),
        botch: gettext("Der Held verwechselt die Spur und folgt einer falschen Fährte. So trifft er vielleicht auf eine gefährliche Kreatur oder jagt den falschen Leuten hinterher."),
        improvement_cost: :c,
        description: "Um eine Wildfährte aufzunehmen oder der Spur eines flüchtigen Verbrechers durch einen Wald zu folgen, ist eine Probe auf [Fährtensuchen] unerlässlich.\n Das Talent kann ebenfalls dazu benutzt werden, die eigenen Spuren in der Wildnis zu verwischen und es so Verfolgern erschweren, die eigene Fährte zu entdecken.",
        reference: {gettext("Basis Regelwerk"), 198},
        examples: [
          %{
            action: "Frische Fußspuren im Schnee entdecken",
            modifier: "+5"
          },
          %{
            action: "Spur eines Bären identifizieren",
            modifier: "+3"
          },
          %{
            action: "Der Spur eines Menschen durch den Wald folgen",
            modifier: "+1"
          },
          %{
            action: "Ungefähres Alter einer Spur schätzen",
            modifier: "+/- 0"
          },
          %{
            action: "Drei Tage alte Spuren eines Kampfes identifizieren",
            modifier: "-1"
          },
          %{
            action: "Exakte Bestimmung von Art und Gewicht eines Tieres",
            modifier: "–3"
          },
          %{
            action: "Vom Regen verwischten Spuren folgen",
            modifier: "-5"
          },
          %{
            action: "Eigene Fährte verwischen",
            modifier: "Vergleichsprobe (Fährtensuchen [eigene Fährte verwischen] gegen Fährtensuchen [humanoide Spuren])"
          }
        ]
      }, %{
        id: 9,
        name: gettext("Fahrzeuge"),
        category: :crafting,
        check: {:ch, :ff, :ko},
        applications: [
          %{name: gettext("Kampfmanöver")},
          %{name: gettext("Langstrecke")},
          %{name: gettext("Verfolgungsjagden")},
          %{name: gettext("Wettrennen")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Fahrzeug"),
        quality: gettext("Die Distanz bis zum Ziel kann schneller überwunden werden."),
        failed: gettext("Das Fahrzeug bewegt sich schwerfällig oder dem Helden gelingt es nicht, es in Bewegung zu setzen."),
        success: gettext("Das Fahrzeug kommt gut voran und schafft die Strecke in Rekordzeit."),
        botch: gettext("Das Fahrzeug erleidet einen Achsenbruch oder fällt während der Fahrt mitsamt dem Fahrer um, und der Held erleidet Fallschaden."),
        improvement_cost: :a,
        description: "Ob Eselskarren oder Streitwagen, mit diesem Talent lassen sich alle Fahrzeuge lenken, die von Tieren (oder Sklaven) gezogen werden.\nEs kann komplexe Fahrzeuge geben, die nicht jeder lenken kann. Sie gelten als [komplex] und erfordern ein Berufsgeheimnis.",
        reference: {gettext("Basis Regelwerk"), 207},
        examples: [
          %{
            action: "Ruhige Fahrt auf der Reichsstraße",
            modifier: "+5"
          },
          %{
            action: "Reisen auf einer viel befahrenen Straße",
            modifier: "+3"
          },
          %{
            action: "Holprige Straße",
            modifier: "+1"
          },
          %{
            action: "Unruhige Fahrt",
            modifier: "+/- 0"
          },
          %{
            action: "Riskantes Wendemanöver einleiten",
            modifier: "-1"
          },
          %{
            action: "Rammangriff ausführen",
            modifier: "–3"
          },
          %{
            action: "Unter Beschuss aus einer Stadt fliehen",
            modifier: "-5"
          }
        ]
      }, %{
        id: 10,
        name: gettext("Fesseln"),
        category: :nature,
        check: {:kl, :ff, :kk},
        applications: [
          %{name: gettext("Fesselungen")},
          %{name: gettext("Knotenkunde")},
          %{name: gettext("Netze knüpfen")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: gettext("nein, eventuell ja bei Helmen, Panzerhandschuhen, etc."),
        tools: gettext("Fessel"),
        quality: gettext("Die Fessel hält länger und kann gegebenenfalls schwerer geöffnet werden."),
        failed: gettext("Dem Held gelingt nur ein Knoten von schlechter Qualität. Das Befreien daraus ist leichter als üblich."),
        success: gettext("Der Held hat einen stabilen Knoten gemacht. Für Qualitätsstufen, Vergleichs- und Sammelproben gilt: FP = doppelter FW."),
        botch: gettext("Der Held hat einen Knoten gemacht, der sich in jeder Lage löst – oder der denkbar ungünstigsten."),
        improvement_cost: :a,
        description: "Mit [Fesseln] kann ein Held Schwachstellen bei einer Fesselung eines Gefangenen vermeiden und dafür sorgen, dass er sich nicht bei der erstbesten Gelegenheit befreit. Darüber hinaus gibt das Talent Auskunft über das Wissen eines Helden für verschiedene Knotentechniken, das Spleißen von Tauen und das Knüpfen von Netzen. Entfesselungen werden über das Talent [Körperbeherrschung (Entwinden)] oder [Kraftakt (Ziehen & Zerren)] geregelt. Um jemand anderen zu entfesseln, ist entweder ein scharfer Gegenstand oder [Körperbeherrschung (Entwinden)] notwendig.",
        reference: {gettext("Basis Regelwerk"), 199},
        examples: [
          %{
            action: "Held ist nicht abgelenkt und kann sich konzentrieren",
            modifier: "+1"
          },
          %{
            action: "Held ist leicht abgelenkt",
            modifier: "-1"
          },
          %{
            action: "Fesseln",
            modifier: "Erfolgsprobe; Gegner muss sich mit einer Sammelprobe befreien"
          }
        ]
      }, %{
        id: 11,
        name: gettext("Fischen & Angeln"),
        category: :nature,
        check: {:ff, :ge, :ko},
        applications: [
          %{name: gettext("Salzwassertiere")},
          %{name: gettext("Süßwassertiere")},
          %{name: gettext("Wasserungeheuer")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: gettext("ja, (beim Speerfischen) oder nein (beim Reusenfang oder dem Fischen mit Netzen)"),
        tools: gettext("Angel mit Schnur, Netz oder Reuse, Speer"),
        quality: gettext("Die Fische sind wohlschmeckender als bei einem durchschnittlichen Fang."),
        failed: gettext("Kein Fisch beißt an oder geht ins Netz."),
        success: gettext("Die Zahl der Rationen ist sehr hoch. Für Qualitätsstufen, Vergleichs- und Sammelproben gilt: FP = doppelter FW."),
        botch: gettext("Der Angler fällt ins Wasser und die Angel geht verloren."),
        improvement_cost: :a,
        description: "Proben auf [Fischen & Angeln] beurteilen den Erfolg eines Helden bei der Jagd auf schmackhafte Wassertiere. Eine erfolgreiche Probe gibt an, dass man nicht nur etwas gefangen hat, sondern es sich in der Tat um Fische oder Meeresfrüchte handelt. Die Menge ist nicht nur von der Umgebung, sondern ebenso von der verwendeten Methode abhängig. Mittels Netzen und Reusen kann man mehr Fische innerhalb des gleichen Zeitraums fangen als mit einer einzigen Angel und einem Wurmköder.",
        reference: {gettext("Basis Regelwerk"), 199},
        examples: [
          %{
            action: "Einen Tag lang Fische angeln, um sie am Abend über dem Lagerfeuer zu braten",
            modifier: "1 QS = 1 Ration (für eine Person und einen Tag), bei Netzen und Reusen QS x 3"
          }
        ]
      },  %{
        id: 12,
        name: gettext("Fliegen"),
        category: :physical,
        check: {:mu, :in, :ge},
        applications: [
          %{name: gettext("Kampfmanöver")},
          %{name: gettext("Langstreckenflug")},
          %{name: gettext("Verfolgungsjagden")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("das entsprechende Fluggerät"),
        quality: gettext("Distanzen können schneller überwunden werden."),
        failed: gettext("Das Flugmanöver ist misslungen und muss abgebrochen werden."),
        success: gettext("Dem Held ist nicht nur das Manöver gelungen, sondern er hat eine zusätzliche Aktion in dieser Runde."),
        botch: gettext("Der Held stürzt ab."),
        improvement_cost: :b,
        description: "Um Gegenstände wie Hexenbesen oder fliegende Teppiche aktiv zu steuern, beispielsweise um durch eine enge Straßenschlucht oder durch ein offenes Fenster zu fliegen, ist eine Probe auf Fliegen nötig. Unter das Talent fällt außerdem das Steuern von Flugreittieren, flugfähigen Dämonen und anderen Wesenheiten, die einen Helden durch die Luft transportieren können. Der durchschnittliche Held wird eher selten Proben auf dieses Talent ablegen, eine Hexe mit ihrem Fluggerät deutlich häufiger.\n[Komplexe] Fluggeräte sind vor allem Fliegende Teppiche, die man nur fliegen kann, wenn man ein magisches Zauberwort oder eine bestimmte Geste kennt, die man vollführen muss.",
        reference: {gettext("Basis Regelwerk"), 188},
        examples: [
          %{
            action: "Ein kurzer, ruhiger Flug von etwa 100 Schritt",
            modifier: "+5"
          },
          %{
            action: "Ein mehrstündiger Flug ohne Gesäßschmerzen",
            modifier: "+3"
          },
          %{
            action: "Rasanter Flug durch eine Straßenschlucht",
            modifier: "+1"
          },
          %{
            action: "Überraschende Wendemanöver",
            modifier: "+/- 0"
          },
          %{
            action: "Durch ein schmales Fenster fliegen",
            modifier: "-1"
          },
          %{
            action: "Looping",
            modifier: "–3"
          },
          %{
            action: "Sicherer Flug durch einen Luftschacht",
            modifier: "-5"
          }
        ]
      }, %{
        id: 13,
        name: gettext("Gassenwissen"),
        category: :social,
        check: {:kl, :in, :ch},
        applications: [
          %{name: gettext("Beschatten")},
          %{name: gettext("Informationssuche")},
          %{name: gettext("Ortseinschätzung")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: gettext("nein, eventuell ja bei bestimmten Situationen, zum Beispiel, wenn die Rüstung den Anschein eines Gardisten oder Adligen erweckt"),
        tools: nil,
        quality: gettext("Der Held erhält mehr Informationen oder erlangt sie schneller als erwartet."),
        failed: gettext("Der Held erhält keine hilfreichen Informationen."),
        success: gettext("Der Held entdeckt ein besonders gutes, aber günstiges Gasthaus, erhält mehr Informationen, als er erwartet hat, oder es gelingt ihm, einen Kontaktmann zu finden, der ihm exzellente Konditionen anbietet."),
        botch: gettext("Der Held gerät in den Hinterhalt einer Bande Schurken, die ihn ausplündern wollen."),
        improvement_cost: :c,
        description: "[Gassenwissen] spiegelt die Erfahrung wider, wie gut man sich in zwielichtigen Stadtvierteln auskennt, wo man den richtigen Ansprechpartner findet oder wo man sich in eine billige Herberge einquartieren kann. Dieses Wissen lässt sich in den meisten Fällen nicht nur auf den Heimatort des Abenteurers, sondern ebenfalls auf fremde Städte anwenden.\nProben geben dem Helden Hilfestellung auf Fragen zur Ortseinschätzung: Wo patrouilliert die Stadtwache heute Nacht? In welcher Taverne treffe ich am ehesten auf ein Mitglied einer Unterweltbande? Wo kann ich am günstigsten übernachten? Wie viele Silbertaler brauche ich, um vom Bettler meines Vertrauens eine Gefälligkeit zu verlangen?\nWill man einen Hehler finden, um verbotene Waren loszuwerden oder zu kaufen, ist ebenfalls eine Probe auf [Gassenwissen] unumgänglich.\nAußerdem kann man mit diesem Talent jemand anderen beschatten. Dies umfasst eine gute Sichtposition und Kenntnis des richtigen Abstands zum Zielobjekt, aber auch allgemeine Unauffälligkeit auf den Straßen. Damit sind jedoch nicht zwangsweise Schleichen und sich Verstecken gemeint, was unter das Talent Verbergen fällt. Zu guter Letzt dient das Talent dazu zu wissen, wie und wo man gute Kontakte knüpfen kann, beispielsweise zu Wirten, Auftraggebern und vor allem zwielichtigem Gesindel.",
        reference: {gettext("Basis Regelwerk"), 196},
        examples: [
          %{
            action: "Nächste Armenspeisung finden",
            modifier: "+5"
          },
          %{
            action: "Günstigste Übernachtungsmöglichkeit finden",
            modifier: "+3"
          },
          %{
            action: "Gerüchte aufschnappen",
            modifier: "+1"
          },
          %{
            action: "Einen Schwarzmarkt finden",
            modifier: "+/- 0"
          },
          %{
            action: "Informationen über Alrik den Schläger erhalten",
            modifier: "-1"
          },
          %{
            action: "Einen Giftmischer finden",
            modifier: "–3"
          },
          %{
            action: "Hehler für gestohlenes magisches Artefakt finden",
            modifier: "-5"
          },
          %{
            action: "Beschatten",
            modifier: "Vergleichsprobe (Gassenwissen gegen Sinnesschärfe)"
          }
        ]
      }, %{
        id: 14,
        name: gettext("Gaukeleien"),
        category: :physical,
        check: {:mu, :ch, :ff},
        applications: [
          %{name: gettext("Jonglieren")},
          %{name: gettext("Possenreißen")},
          %{name: gettext("Verstecktricks")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("je nach Trick z.B. Bälle, Fackel, Schlangen, Spielkarten"),
        quality: gettext("Der Trick ist besonders gut gelungen und die Zuschauer applaudieren mehr."),
        failed: gettext("Der Trick funktioniert nicht richtig, kleine Fehler schleichen sich bei dem Versuch ein. Das Publikum ist enttäuscht."),
        success: gettext("Die Zuschauer sind fasziniert, halten den Trick gar für echte Magie, und potenzielle Geldeinnahmen des Gauklers verdoppeln sich."),
        botch: gettext("Der Held wird bei der Präsentation ausgebuht, da ihm ein Missgeschick passiert (mit Jonglierkeule einen Zuschauer getroffen, mit Pyrotechnik den Bürgermeister verletzt etc.)."),
        improvement_cost: :a,
        description: "Wenn es gilt, auf einem Jahrmarkt oder in einer Taverne ein paar Silbermünzen als Jongleur zu verdienen oder sein Gegenüber mit kleinen Zaubertricks zu verblüffen, wird auf das Talent [Gaukeleien] gewürfelt. Hierunter fallen unter anderem Jonglieren, Hütchenspiel und Possenreißen.\nBesonders nützlich können sich [Gaukeleien] beim Verstecken von kleinen Gegenständen am Körper erweisen.",
        reference: {gettext("Basis Regelwerk"), 188},
        examples: [
          %{
            action: "Einfachste Kartentricks",
            modifier: "+5"
          },
          %{
            action: "Ein Kind zum Lachen bringen durch Possenreißen",
            modifier: "+3"
          },
          %{
            action: "Ein kleiner Kartentrick",
            modifier: "+1"
          },
          %{
            action: "Mit Tricks in einer Schänke (Fertigkeitspunkte) Heller verdienen",
            modifier: "+/- 0"
          },
          %{
            action: "Mit drei brennenden Fackeln jonglieren",
            modifier: "-1"
          },
          %{
            action: "Mit fünf Kugeln jonglieren",
            modifier: "–3"
          },
          %{
            action: "Ein mürrisches Publikum zum Lachen bringen",
            modifier: "-5"
          }
        ]
      }, %{
        id: 15,
        name: gettext("Geographie"),
        category: :knowledge,
        check: {:kl, :kl, :in},
        applications: [
          %{
            name: gettext("Einzelne Region"),
            selection: regions(),
            limit: 0
          }
        ],
        uses: [gettext("Kartographie")],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("mehr Detailinformationen zur Bevölkerung, Örtlichkeiten und Flussübergängen"),
        failed: gettext("Der Held hat keine Ahnung."),
        success: gettext("Der Held kennt viele Details der Region: Herrscher, Bevölkerungszahlen, Bräuche, Flussverläufe und Brücken."),
        botch: gettext("Der Held erinnert sich an völlig falsche geographische Details: Einwohnerzahlen von Städten stimmen nicht, Brücken befinden sich an anderer Stelle als gedacht."),
        improvement_cost: :b,
        description: "Da Helden viel auf Reisen sind, ist es sehr hilfreich, eine Vorstellung zu haben, wie die Welt an Orten aussieht, die man bisher nie gesehen hat. Das Talent [Geographie] ist von Nutzen, um seinen Weg zu einem gewünschten Ziel zu finden, gangbare Pässe und sichere Furten ausfindig zu machen oder eine Vorstellung zu haben, wie weit eine geplante Reise sein wird und welche Schwierigkeiten der Weg bereithält. Zur Anwendung des Talents gehören außerdem das Verstehen und der Einsatz von Landkarten.",
        reference: {gettext("Basis Regelwerk"), 202},
        examples: [
          %{
            action: "Sich in seiner Heimatstadt auskennen",
            modifier: "+5"
          },
          %{
            action: "Informationen über die Umgebung des eigenen Heimatortes",
            modifier: "+3"
          },
          %{
            action: "Wissen, wohin eine Reichstraße führt",
            modifier: "+1"
          },
          %{
            action: "Die Kenntnis über die Bevölkerungsgröße einer bekannten Stadt",
            modifier: "+/- 0"
          },
          %{
            action: "Eine Brücke über einen Fluss ausfindig machen",
            modifier: "-1"
          },
          %{
            action: "Eine Schätzung, wie weit der Weg von Gareth nach Festum ist",
            modifier: "–3"
          },
          %{
            action: "Schleichwege in einer unbekannten Baronie kennen",
            modifier: "-5"
          }
        ]
      }, %{
        id: 16,
        name: gettext("Geschichtswissen"),
        category: :knowledge,
        check: {:kl, :kl, :in},
        applications: [
          %{
            name: gettext("Einzelne Region"),
            selection: regions(),
            limit: 0
          }
        ],
        uses: nil,
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("mehr Details zu historischen Persönlichkeiten und Epochen"),
        failed: gettext("Der Held hat keine Ahnung."),
        success: gettext("Der Held kennt besonders viele Details über ein bestimmtes Ereignis oder eine historische Person."),
        botch: gettext("Der Held kann zu diesem Thema nur falsche Informationen beitragen: er irrt sich in Daten und Ereignissen."),
        improvement_cost: :b,
        description: "Tausende von Jahren lässt sich die Geschichte Aventuriens in alten Texten nachverfolgen, Geschichten und Gesänge anderer Völker reichen noch viel weiter zurück in die Vergangenheit.\n Mithilfe dieses Talents kann man seine Kenntnisse der Geschichtskunde überprüfen.",
        reference: {gettext("Basis Regelwerk"), 202},
        examples: [
          %{
            action: "Kaiser Hal kennen",
            modifier: "+5"
          },
          %{
            action: "Den Fall Bosparans datieren",
            modifier: "+3"
          },
          %{
            action: "Hela-Horas kennen",
            modifier: "+1"
          },
          %{
            action: "Anführer des Orkensturms benennen",
            modifier: "+/- 0"
          },
          %{
            action: "Datierung der Flut von Havena",
            modifier: "-1"
          },
          %{
            action: "Kenntnis, was genau Elem zerstörte",
            modifier: "–3"
          },
          %{
            action: "Exakte Datierung der Ausgaben der Enzyclopaedia Magica",
            modifier: "-5"
          }
        ]
      }, %{
        id: 17,
        name: gettext("Götter & Kulte"),
        category: :knowledge,
        check: {:kl, :kl, :in},
        applications: [
          %{
            name: gettext("je nach Gottheit oder Philosophie, z. B. Praios, Rondra, Swafnir, Namenloser, Rastullah",
            limit: 0,
            modify: true)
          }
        ],
        uses: nil,
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("mehr Details zu Kulten, Göttern und Priestern"),
        failed: gettext("Der Held hat keine Ahnung."),
        success: gettext("Der Held hat detaillierte Einsichten in das Thema und kennt selbst spezielle Rituale, Gebetstexte oder philosophische Grundlagen."),
        botch: gettext("Der Held verwechselt kultische Handlungen und Ansichten dieser Kirche mit einer anderen."),
        improvement_cost: :b,
        description: "In einer Welt, in der Götter real sind und ihre Diener wahrhafte Wunder wirken können, ist das Wissen um Alveraniare, Halbgötter und ihre Sendboten mehr wert als Gold. Dies gilt besonders für Geweihte, die Göttersagen und das Leben der Heiligen genauso beherrschen müssen wie die richtigen Rituale und Gebete. Zu diesem Talent gehören außerdem Kenntnisse der Philosophie und fremdartiger Denkrichtungen.",
        note: gettext("Steht bei der Beschreibung einer Kirche oder eines Kultes explizit dabei, dass der Held zunächst ein spezielles Wissen darüber erlangen muss (also ein Berufsgeheimnis), so ist diese Kirche oder Kult zunächst kein Anwendungsgebiet dieses Talents."),
        reference: {gettext("Basis Regelwerk"), 203},
        examples: [
          %{
            action: "Tägliches Gebet zu Ehren der Götter kennen",
            modifier: "+5"
          },
          %{
            action: "Einen Geburtssegen aufsagen",
            modifier: "+3"
          },
          %{
            action: "Die Bedeutung einer praiotischen Sphärenkugel kennen",
            modifier: "+1"
          },
          %{
            action: "Oberflächliches Wissen über fremde Kulte",
            modifier: "+/- 0"
          },
          %{
            action: "Als Zwölfgöttergläubiger die Zeremonien der Lowanger Dualisten kennen",
            modifier: "-1"
          },
          %{
            action: "Als Mittelreicher die Rituale eines Novadis kennen",
            modifier: "–3"
          },
          %{
            action: "Die Ziele der echsischen Sekte von Scr’Shrf kennen",
            modifier: "-5"
          }
        ]
      }, %{
        id: 18,
        name: gettext("Handel"),
        category: :crafting,
        check: {:kl, :in, :ch},
        applications: [
          %{name: gettext("Buchhaltung")},
          %{name: gettext("Feilschen")},
          %{name: gettext("Geldwechsel")},
          %{name: gettext("Hehlerei"), requirement: {:mundane_ability, 1}}, # TODO: id
        ],
        uses: [gettext("Rosstäuscher")],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("Der Held kann präziser den Preis bestimmen."),
        failed: gettext("Der Held bekommt nicht so viel wie erhofft."),
        success: gettext("Der Held bekommt die Ware zu einem Spottpreis bzw. kann sie zu Wucherpreisen loswerden – ohne dass sein Handelspartner es ihm übel nimmt. Die Preiserhöhung oder der Nachlass sollte mindestens 50 % betragen."),
        botch: gettext("Der Held wird über den Tisch gezogen oder der Handelspartner weigert sich, Geschäfte mit dem Helden zu machen. Die Preiserhöhung oder der Nachlass sollte mindestens 50 % betragen."),
        improvement_cost: :b,
        description: "Um ein gutes Geschäft machen zu können, muss man Kenntnisse von der Marktlage haben und eine Ahnung, wo man gut günstig ein- und teuer verkaufen kann. Auch der preisgünstige und sichere Warentransport von einem Ort zum anderen gehört zu diesem Talent.\nHinzu kommen der korrekte Umgang mit fremdländi- schen Münzen, der Umgang mit Zöllen, Abgaben und Wechselkursen, und der Verleih und die Verzinsung von Geld und die Verwaltung von Vermögen. Feilschen ge- hört ebenfalls zu diesem Talent.",
        reference: {gettext("Basis Regelwerk"), 208},
        examples: [
          %{
            action: "Rohstoffe sind billiger als das Endprodukt",
            modifier: "+5"
          },
          %{
            action: "Als Bauer seine Rüben in der Stadt verkaufen",
            modifier: "+3"
          },
          %{
            action: "Im Herbst sind Schweine am billigsten",
            modifier: "+1"
          },
          %{
            action: "Fernhandel ist riskant, aber lukrativ",
            modifier: "+/- 0"
          },
          %{
            action: "Von Vinsalt nach Kuslik reisen, ohne Zoll zu zahlen",
            modifier: "-1"
          },
          %{
            action: "Den Preis eines Ballens al’anfanischer Seide in Festum kennen",
            modifier: "–3"
          },
          %{
            action: "Güldenland- und Uthuriahandel planen",
            modifier: "-5"
          },
          %{
            action: "Auf dem Markt feilschen",
            modifier: "Vergleichsprobe (Handel [Feilschen] gegen Handel [Feilschen]) (Nachdem die QS des Verlierers von den QS des Gewinners abgezogen wurden, steigt oder fällt Kaufpreis um die verbliebenen QS x 10 in Prozent nach Wahl des Siegers, maximal jedoch um 50 %.)"
          }
        ]
      }, %{
        id: 19,
        name: gettext("Heilkunde Gift"),
        category: :crafting,
        check: {:mu, :kl, :in},
        applications: [
          %{name: gettext("alchimistisches Gift")},
          %{name: gettext("mineralisches Gift")},
          %{name: gettext("pflanzliches Gift")},
          %{name: gettext("tierisches Gift")}
        ],
        uses: nil,
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Gegenmittel"),
        quality: gettext("Der Held kann das Gift schneller bestimmen."),
        failed: gettext("Der Held hat keine Ahnung und kennt keine Möglichkeit der Heilung."),
        success: gettext("Der Patient kann vollständig entgiftet werden, ohne dass der Held das passende Gegenmittel verwenden musste."),
        botch: gettext("Der Held ordnet einen (schädlichen) Aderlass an oder hat den Patienten bei der Behandlung verletzt oder gar zusätzlich vergiftet (1W6 SP)."),
        improvement_cost: :b,
        description: "Um einer vergifteten Person zu helfen, muss das Gift identifiziert und eine Behandlung, beispielsweise mit einem Gegengift, vorgenommen werden. Mit einer um die Stufe des Giftes erschwerten Probe auf das Talent kann einem Patienten geholfen werden. Manche Gegenmittel erfordern jedoch seltene Ingredienzien, die erst aufwendig beschafft werden müssen. Ist das Gegenmittel verabreicht, so ist die Wirkung des Giftes gestoppt.\nScheitert die Probe, erkennt der Heiler das Gift nicht oder kennt kein geeignetes Gegenmittel.\nDas Wissen über [komplexe] Gifte erfordert ein Berufsgeheimnis.",
        note: gettext("[Behandlung von Giften und Krankheiten]\nDurch eine gelungene Probe auf Heilkunde Gift oder Krankheiten kann ein Held das Wissen um die genaue Art des Giftes bzw. der Krankheit sowie die passende Behandlung eines Patienten in Erfahrung bringen bzw. erinnert sich an die richtige Behandlungsmethode. Behandlung bedeutet in diesem Fall, dass er alle Informationen zu den Abschnitten Behandlung und Gegenmittel erhält und sich auch entsprechend um den Patienten kümmern kann, damit dieser davon profitiert."),
        reference: {gettext("Basis Regelwerk"), 208},
        examples: nil
      }, %{
        id: 20,
        name: gettext("Heilkunde Krankheiten"),
        category: :crafting,
        check: {:mu, :in, :ko},
        applications: [
          %{
            name: gettext("jeweilige Krankheit (z. B. Sumpffieber)"),
            modify: true,
            limit: 0
          }
        ],
        uses: nil,
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Heilmittel"),
        quality: gettext("Der Held kann die Krankheit schneller bestimmen."),
        failed: gettext("Der Held hat keine Ahnung und kennt weder Heilmittel noch die passende Behandlung."),
        success: gettext("Der Patient ist geheilt, ohne dass der Held ein Heilmittel verwenden musste. Zudem steckt er sich nicht beim Erkrankten an."),
        botch: gettext("Der Held hat dem Patienten bei der Behandlung geschadet (1W6 SP) oder der Krankheitsverlauf verschlimmert sich. Zudem besteht für den Helden bei ansteckenden Krankheiten eine 25 % höhere Chance, sich bei dem Patienten anzustecken."),
        improvement_cost: :b,
        description: "Mit einer um die Stufe der Krankheit erschwerten Probe lassen sich die Krankheit und eine mögliche Behandlung ermitteln. In manchen Fällen sind jedoch exotische Heilmittel vonnöten, die erst beschafft werden müssen. Meist endet die Krankheit nach der Behandlung nicht abrupt, doch ihre Auswirkungen werden gemildert und die Dauer der Erkrankung verkürzt.\nDas Wissen über [komplexe] Krankheiten erfordert ein Berufsgeheimnis.",
        note: gettext("[Behandlung von Giften und Krankheiten]\nDurch eine gelungene Probe auf Heilkunde Gift oder Krankheiten kann ein Held das Wissen um die genaue Art des Giftes bzw. der Krankheit sowie die passende Behandlung eines Patienten in Erfahrung bringen bzw. erinnert sich an die richtige Behandlungsmethode. Behandlung bedeutet in diesem Fall, dass er alle Informationen zu den Abschnitten Behandlung und Gegenmittel erhält und sich auch entsprechend um den Patienten kümmern kann, damit dieser davon profitiert."),
        reference: {gettext("Basis Regelwerk"), 208},
        examples: nil
        }, %{
          id: 21,
          name: gettext("Heilkunde Seele"),
          category: :crafting,
          check: {:in, :ch, :ko},
          applications: [
            %{name: gettext("Unterdrückung von Ängsten")},
            %{name: gettext("Unterdrückung von Persönlichkeitsschwächen")},
            %{name: gettext("Unterdrückung von Schlechten Eigenschaften")}
          ],
          uses: nil,
          encumbrance: false,
          encumbrance_condition: nil,
          tools: nil,
          quality: gettext("Die Unterdrückung des Nachteils hält länger an."),
          failed: gettext("Der Held hat keine Ahnung, wie er dem Patienten helfen kann."),
          success: gettext("Der Patient kann einen Nachteil (Angst, Persönlichkeitsschwäche oder Schlechte Eigenschaft) für einen ganzen Tag unterdrücken."),
          botch: gettext("Der Held hat den Patienten bei der Behandlung verstört oder seinem Geist anderweitig geschadet. Der Patient erhält für einen Tag eine Stufe des Zustands Furcht oder Verwirrung."),
          improvement_cost: :b,
          description: "Wenn der Held panische Angst vor Feuer hat, von Alpträumen verfolgt wird oder von dämonischem Wirken traumatisiert ist, sind Seelenheiler gefragt. Ein kurzes Gespräch zwischen Heiler und Patient reicht aus, um seine Nachteile zu unterdrücken: Der Seelenheilkundige kann bei gelungener Probe bei seinem Patienten eine Angst, eine Schlechte Eigenschaft oder eine Persönlichkeitsschwäche für FP in Minuten unterdrücken.\nBei einer längeren Sitzung zwischen Heiler und Patient, die mehrere Stunden dauern kann, werden die oben genannten Nachteile für Qualitätsstufe in Stunden unterdrückt.",
          reference: {gettext("Basis Regelwerk"), 209},
          examples: nil
      }, %{
        id: 22,
        name: gettext("Heilkunde Wunden"),
        category: :crafting,
        check: {:kl, :ff, :ff},
        applications: [
          %{name: gettext("Heilung fördern")},
          %{name: gettext("Schmerzen nehmen")},
          %{name: gettext("Stabilisieren")}
        ],
        uses: nil,
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("eventuell Bandagen, chirurgisches Gerät, Kräuter, Nadel und Faden"),
        quality: gettext("Der Held verbraucht weniger Heilkräuter oder kann die Verletzung schneller versorgen."),
        failed: gettext("Der Held kann dem Patienten nicht helfen."),
        success: gettext("Die vollen Fertigkeitspunkte werden bei der nächsten Regenerationsphase zusätzlich zur normalen Regeneration zu den Lebenspunkten des Patienten hinzuaddiert."),
        botch: gettext("Der Held hat den Patienten bei der Behandlung verletzt (1W6 SP)."),
        improvement_cost: :d,
        description: "Verletzungen gehören für Helden zur Tagesordnung. Schnitte, Prellungen und Brüche, aber auch Zahnleiden können mit dem Talent [Heilkunde Wunden] behandelt und die Heilung damit beschleunigt werden. Der Patient erhält QS LeP bei der nächsten Regenerationsphase, zusätzlich zur normalen Regeneration. Eine solche Behandlung dauert 15 Minuten.\nAußerdem kann der Heiler dem Patienten Schmerzen nehmen, die durch LE-Verlust entstanden sind. Für je 1 QS wird eine Stufe des Zustands Schmerz ignoriert. Eine solche Behandlung dauert ebenfalls 15 Minuten. Diese Wirkung hält bis zum Ende der nächsten Regenerationsphase. Außerdem kann ein Held einen Sterbenden stabilisieren.\nDie Anwendungsgebiete [Heilung fördern] und [Schmerzen nehmen] kann ein Held auch auf sich selbst anwenden. Ein Held kann sich aber durch das Talent nicht selbst stabilisieren.",
        reference: {gettext("Basis Regelwerk"), 209},
        examples: nil
      }, %{
      id: 23,
      name: gettext("Holzbearbeitung"),
      category: :crafting,
      check: {:ff, :ge, :kk},
      applications: [
        %{name: gettext("Schlagen & Schneiden")},
        %{name: gettext("Tischlerarbeiten")},
        %{name: gettext("Zimmermannsarbeiten")}
      ],
      uses: nil,
      encumbrance: true,
      encumbrance_condition: nil,
      tools: gettext("je nach zu bearbeitendem Material z. B. Axt, Hobel, Messer, Säge"),
      quality: gettext("Das Werkstück ist schneller fertig oder es wird eine bessere Qualität erzielt."),
      failed: gettext("Der Held kommt mit der Arbeit an dem Werkstück nicht voran."),
      success: gettext("Die Zahl der FP bei dieser Probe verdoppelt sich, der Held erhält aber mindestens 5 FP. Erschwernisse, die durch misslungene Sammelproben aufgebaut wurden, werden komplett abgebaut."),
      botch: gettext("Ein Patzer sorgt dafür, dass die angesammelten QS auf 0 sinken und keine weitere Probe für dieses Vorhaben angewandt werden kann."),
      improvement_cost: :b,
      description: "Dieses Talent deckt den gesamten Bereich der Verarbeitung von Holz ab – vom fachgerechten Fällen über das Zurechtschneiden von Brettern und Balken bis hin zur Anfertigung von Gerätschaften wie Musikinstrumenten oder Bögen aus Holz und dem Bau von Booten, Holz- und Fachwerkhäusern oder Palisaden. Auch die Verarbeitung von Horn, Eis und Mammuton fällt unter dieses Talent. Unter dem Anwendungsgebiet [Schlagen & Schneiden] ist das Fällen von Bäumen zusammengefasst. Tischlerarbeiten umfassen die Bearbeitung von Holzoberflächen, Zimmermänner hingegen bearbeiten das Holz vorher und bringen es in die gewünschte Form.",
      reference: {gettext("Basis Regelwerk"), 210},
      examples: [
        %{
          action: "Einen Pfeil anfertigen",
          time: "10 Minuten",
          checks: "10 Proben"
        },
        %{
          action: "Eine alte Eiche fällen",
          time: "20 Minuten",
          checks: "beliebig viele Proben"
        },
        %{
          action: "Einen Stuhl aus Brettern herstellen",
          time: "1 Stunde",
          checks: "10 Proben"
        },
        %{
          action: "Eine Truhe oder einen Schrank aus Brettern anfertigen",
          time: "2 Stunden",
          checks: "5 Proben"
        },
        %{
          action: "Aus einem Elefantenstoßzahn eine Statue schnitzen",
          time: "1 Tag",
          checks: "4 Proben"
        },
        %{
          action: "Ein Musikinstrument anfertigen",
          time: "2 Tage",
          checks: "3 Proben"
        }
      ]
    }, %{
    id: 24,
    name: gettext("Klettern"),
    category: :physical,
    check: {:mu, :ge, :kk},
    applications: [
      %{name: gettext("Baumklettern")},
      %{name: gettext("Bergsteigen")},
      %{name: gettext("Eisklettern")},
      %{name: gettext("Fassadenklettern")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("eventuell Kletterausrüstung"),
    quality: gettext("Der Held kommt schneller an seinem Ziel an."),
    failed: gettext("Der Held braucht viel länger als üblich, verletzt sich leicht (1W3 SP), traut sich nicht, zu klettern, oder hängt fest."),
    success: gettext("Ohne Schwierigkeiten und viel schneller als gewöhnlich hat der Held den Aufstieg geschafft. Zuschauer halten ihn für den besten Kletterer Deres. Für Qualitätsstufen, Vergleichs- und Sammelproben gilt: FP = doppelter FW."),
    botch: gettext("Der Held rutscht ab und fällt"),
    improvement_cost: :b,
    description: "Wenn ein Held über eine Burgmauer oder an einer steilen Klippe entlangsteigt, steht eine Probe auf Klettern an. Eine misslungene Probe bedeutet nicht automatisch einen Sturz, eventuell traut sich ein Held erst gar nicht zu klettern, verletzt sich oder braucht furchtbar lange, um sein Ziel zu erreichen.",
    reference: {gettext("Basis Regelwerk"), 189},
    examples: [
      %{
        action: "Auf den ersten Ast eines kleinen Baumes klettern",
        modifier: "+5"
      },
      %{
        action: "Über eine zwei Schritt hohe Mauer kommen",
        modifier: "+3"
      },
      %{
        action: "Einen hohen Baum erklettern",
        modifier: "+1"
      },
      %{
        action: "Zum Fenster im ersten Stockwerk klettern",
        modifier: "+/- 0"
      },
      %{
        action: "Die Fassade eines hohen Gebäudes erklimmen",
        modifier: "-1"
      },
      %{
        action: "Schwierige Wand mit wenigen Griffmöglichkeiten",
        modifier: "–3"
      },
      %{
        action: "Eine feuchte Burgmauer hochsteigen",
        modifier: "-5"
      }
    ]
  }, %{
    id: 25,
    name: gettext("Körperbeherrschung"),
    category: :physical,
    check: {:ge, :ge, :ko},
    applications: [
      %{name: gettext("Akrobatik")},
      %{name: gettext("Balance")},
      %{name: gettext("Entwinden")},
      %{name: gettext("Kampfmanöver")},
      %{name: gettext("Laufen")},
      %{name: gettext("Springen")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Der Abenteurer kann sich schneller aus einer Fesselung befreien."),
    failed: gettext("Die Handlung des Helden geht teilweise schief, er braucht länger und macht Fehler oder muss die Handlung abbrechen."),
    success: gettext("Dem Held gelingt seine Handlung und er hat noch eine zusätzliche Aktion zur Verfügung. Und was immer der Held getan hat: Es sah elegant aus."),
    botch: gettext("Der Held stürzt und erleidet Schaden (1W6 SP)."),
    improvement_cost: :d,
    description: "Um weit zu springen, schnell zu sprinten, sich nach einem Sturz abzurollen, das Gleichgewicht auf einem Drahtseil zu bewahren oder anderweitig seinen Körper zu besonderen Leistungen zu  animieren, ist das Talent [Körperbeherrschung] nötig. Hierunter fallen akrobatische Aktionen und die sportlichen Herausforderungen von Athleten ebenso wie das Entwinden aus Fesseln, Tentakeln oder Wurfnetzen.\n[Komplexe] Anwendungen von Körperbeherrschung sind vor allem unterschiedliche Sportspiele wie Imman.",
    reference: {gettext("Basis Regelwerk"), 189},
    examples: [
      %{
        action: "Einen Purzelbaum schlagen",
        modifier: "+5"
      },
      %{
        action: "Auf einem Balken balancieren",
        modifier: "+3"
      },
      %{
        action: "Ein Rad schlagen",
        modifier: "+1"
      },
      %{
        action: "Handstand",
        modifier: "+/- 0"
      },
      %{
        action: "Bei Sturm auf einem Schiff auf den Beinen bleiben",
        modifier: "-1"
      },
      %{
        action: "Auf Skiern einen gefährlichen Abhang hinunterfahren",
        modifier: "–3"
      },
      %{
        action: "Auf einem dünnen Drahtseil laufen",
        modifier: "-5"
      },
      %{
        action: "Sich aus einem Seil oder Netz entwinden",
        modifier: "Sammelprobe (gegen 10 + QS der Probe auf Fesseln (Fesselungen) des Gegners, Zeitintervall 1 Kampfrunde, maximal 7 Proben erlaubt)"
      }
    ]
  }, %{
    id: 26,
    name: gettext("Kraftakt"),
    category: :physical,
    check: {:ko, :kk, :kk},
    applications: [
      %{name: gettext("Drücken & Verbiegen")},
      %{name: gettext("Eintreten & Zertrümmern")},
      %{name: gettext("Stemmen & Heben")},
      %{name: gettext("Ziehen & Zerren")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("eventuell Brecheisen oder Seil"),
    quality: gettext("Für einen kurzen Zeitraum kann der Held mehr Gewicht stemmen oder eine schwere Last länger halten."),
    failed: gettext("Die Handlung des Helden misslingt."),
    success: gettext("Der Held beeindruckt durch seine Muskelkraft alle Zuschauer und gilt fortan als einer der stärksten Aventurier. Für Qualitätsstufen, Vergleichs- und Sammelproben gilt: FP = doppelter FW."),
    botch: gettext("Die Handlung des Helden misslingt völlig. Er stürzt, verhebt sich o.Ä. und verletzt sich dabei (1W6 SP)."),
    improvement_cost: :b,
    description: "Gelegentlich muss ein Held Türen auftreten, sich im Armdrücken gegen einen Thorwaler beweisen oder große Gewichte bewegen. Für alle diese Tätigkeiten ist das Talent [Kraftakt] die richtige Wahl.",
    reference: {gettext("Basis Regelwerk"), 189},
    examples: [
      %{
        action: "Einen Baumstumpf rollen (typische Fichte)",
        modifier: "+5"
      },
      %{
        action: "Einen Almanach zerreißen",
        modifier: "+3"
      },
      %{
        action: "Einen Felsbrocken wegstemmen (ca. 100 Stein)",
        modifier: "+1"
      },
      %{
        action: "Eine verriegelte Türe aufstoßen",
        modifier: "+/- 0"
      },
      %{
        action: "Hufeisen verbiegen",
        modifier: "-1"
      },
      %{
        action: "Einen Backstein zerschlagen",
        modifier: "–3"
      },
      %{
        action: "Einen Karren aus dem Sumpf ziehen",
        modifier: "-5"
      }
    ]
  }, %{
    id: 27,
    name: gettext("Kriegskunst"),
    category: :knowledge,
    check: {:mu, :kl, :in},
    applications: [
      %{name: gettext("Belagerung")},
      %{name: gettext("Feldschlacht")},
      %{name: gettext("Partisanenkampf")},
      %{name: gettext("Seegefechte")},
      %{name: gettext("Tunnelkampf")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("bessere Vorteile während des Gefechts"),
    failed: gettext("Der Held unterliegt einer Fehleinschätzung."),
    success: gettext("Der Held hat einen vortrefflichen Plan, der ihm zusätzliche Vorteile im Kampf einbringt."),
    botch: gettext("Der Held begeht einen kapitalen Planungsfehler, der den Kampf zu seinen Ungunsten beeinflusst oder ihm zumindest extreme Nachteile beschert."),
    improvement_cost: :b,
    description: "Im Gewühl der Schlacht ist es für den Einzelnen kaum möglich zu erkennen, was um ihn herum geschieht. Feldherren, die ganze Armeen in den Krieg führen, müssen daher den Überblick bewahren. Der Held kann seinen Kameraden im Kampf nützliche taktische Hinweise geben.",
    reference: {gettext("Basis Regelwerk"), 203},
    examples: [
      %{
        action: "Mit 20 Gardisten 2 Schurken in die Enge treiben",
        modifier: "+5"
      },
      %{
        action: "Die Versorgung eines Trupps in einer ruhigen Gegend organisieren",
        modifier: "+3"
      },
      %{
        action: "Katapulte auf einer Anhöhe positionieren lassen",
        modifier: "+1"
      },
      %{
        action: "Taktik gegen eine Räuberbande entwerfen",
        modifier: "+/- 0"
      },
      %{
        action: "Berittene Bogenschützen an ein Flussufer abdrängen",
        modifier: "-1"
      },
      %{
        action: "Im richtigen Moment die Reserve an eine Flanke schicken",
        modifier: "–3"
      },
      %{
        action: "Sich aus einer aussichtslosen Lage herausmanövrieren",
        modifier: "-5"
      }
    ]
  }, %{
    id: 28,
    name: gettext("Lebensmittelbearbeitung"),
    category: :crafting,
    check: {:in, :ff, :ff},
    applications: [
      %{name: gettext("Ausnehmen")},
      %{name: gettext("Backen")},
      %{name: gettext("Braten & Sieden")},
      %{name: gettext("Brauen")},
      %{name: gettext("Haltbarmachung")},
      %{name: gettext("Schnapsbrennen"), requirement: true}  # TODO
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("entsprechende Zutaten, Feldküche, Kochutensilien"),
    quality: gettext("Der Geschmack des Essens ist besser als üblich."),
    failed: gettext("Das Essen ist angebrannt oder ungenießbar."),
    success: gettext("Die Mahlzeit ist ein echter Gaumenschmaus, ein gekelterter Wein ein wirklich edler Tropfen."),
    botch: gettext("Das Essen schmeckt nicht nur miserabel, der Konsum hat auch eine schwere Magenverstimmung, Durchfall oder Brechreiz (1W6 SP) zur Folge."),
    improvement_cost: :a,
    description: "Aus guten Zutaten etwas Essbares zu kochen, ist keine Kunst. Wer aber Gäste mit einem wirklich gelungenen Essen bewirten will, kommt an diesem Talent nicht vorbei. Lebensmittelbearbeitung kann zum Braten, Backen oder Haltbarmachen von Speisen eingesetzt werden. Dazu kommt außerdem die Herstellung von Alkoholika.",
    reference: {gettext("Basis Regelwerk"), 210},
    examples: [
      %{
        action: "Ein Ei kochen",
        modifier: "+5"
      },
      %{
        action: "Hartwurst braten",
        modifier: "+3"
      },
      %{
        action: "Einen kräftigen Eintopf für zehn Personen kochen",
        modifier: "+1"
      },
      %{
        action: "Das Fleisch eines gefangenen Hasen haltbar machen",
        modifier: "+/- 0"
      },
      %{
        action: "Ein kräftiges Bier brauen",
        modifier: "-1"
      },
      %{
        action: "Eine Hochzeitstorte backen",
        modifier: "–3"
      },
      %{
        action: "Köstliche Gerichte für ein Bankett zubereiten",
        modifier: "-5"
      }
    ]
  }, %{
    id: 29,
    name: gettext("Lederbearbeitung"),
    category: :crafting,
    check: {:ff, :ge, :ko},
    applications: [
      %{name: gettext("Gerben")},
      %{name: gettext("Kürschnern")},
      %{name: gettext("Lederwaren herstellen")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("Ahle, Falzbein, Lochzange, Messer, Punziereisen, Zange"),
    quality: gettext("Das Werkstück ist schneller fertig oder es wird eine bessere Qualität erzielt."),
    failed: gettext("Der Held kommt mit der Arbeit an dem Werkstück nicht voran."),
    success: gettext("Die Zahl der FP bei dieser Probe verdoppelt sich, der Held erhält aber mindestens 5 FP. Erschwernisse, die durch misslungene Sammelproben aufgebaut wurden, werden komplett abgebaut."),
    botch: gettext("Ein Patzer sorgt dafür, dass die angesammelten QS auf 0 sinken und keine weitere Probe für dieses Vorhaben angewandt werden kann."),
    improvement_cost: :b,
    description: "Vom toten Rind zum fertigen Rindslederstiefel ist es ein weiter Weg: Das Fell muss abgezogen, gereinigt und gegerbt werden, um es danach färben, zurechtschneiden und vernähen zu können. All dies umfasst das Talent [Lederbearbeitung]. Außerdem fällt die Herstellung und Verarbeitung oftmals wertvoller Pelze und Felle darunter.",
    reference: {gettext("Basis Regelwerk"), 210},
    examples: [
      %{
        action: "Ein paar Lederreste zusammennähen",
        time: "10 Minuten",
        checks: "beliebig viele Proben"
      },
      %{
        action: "Eine kaputte Sohle flicken",
        time: "20 Minuten",
        checks: "10 Proben"
      },
      %{
        action: "Ein paar Reiterstiefel nähen",
        time: "4 Stunden",
        checks: "4 Proben"
      },
      %{
        action: "Pelzmantel anfertigen",
        time: "8 Stunden",
        checks: "4 Proben"
      },
      %{
        action: "Einen Sattel herstellen",
        time: "1 Tag",
        checks: "3 Proben"
      },
      %{
        action: "Ledermaske anfertigen",
        time: "2 Tage",
        checks: "5 Proben"
      }
    ]
  }, %{
    id: 30,
    name: gettext("Magiekunde"),
    category: :knowledge,
    check: {:kl, :kl, :in},
    applications: [
      %{name: gettext("Artefakte")},
      %{name: gettext("Magische Wesen")},
      %{name: gettext("Rituale")},
      %{name: gettext("Zaubersprüche")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("mehr Details zu Zaubern, magischen Wesen oder exotischer Magieanwendung"),
    failed: gettext("Der Held hat keine Ahnung."),
    success: gettext("Der Held kennt Herkunft, wirkenden Zauber und Auslöser eines alten Artefaktes."),
    botch: gettext("Der Held hat falsche Vorstellungen und irrt sich, sodass es zu einem gravierenden Fehlurteil kommt."),
    improvement_cost: :c,
    description: "Die Magie ist in Aventurien zwar nicht alltäglich, aber allgegenwärtig. Daher ist es eine Wissenschaft für sich, Zauber anhand der genutzten Gesten oder beobachteten Effekte zu erkennen, den Zweck magischer Artefakte zu verstehen oder das komplexe Muster von Kraftlinien zu lesen.",
    reference: {gettext("Basis Regelwerk"), 204},
    examples: [
      %{
        action: "Ein Magier trägt meistens einen Zauberstab und einen Hut",
        modifier: "+5"
      },
      %{
        action: "Metall verträgt sich nicht mit Magie",
        modifier: "+3"
      },
      %{
        action: "Eine aus den Fingern schießende Flammenlanze heißt Ignifaxius",
        modifier: "+1"
      },
      %{
        action: "Die richtige Geste für einen verbreiteten Zauber kennen",
        modifier: "+/- 0"
      },
      %{
        action: "Die Tricks von Vertrautentieren kennen",
        modifier: "-1"
      },
      %{
        action: "Wissen, was es mit der kritischen Essenz auf sich hat",
        modifier: "–3"
      },
      %{
        action: "Spezielle Zauberrune identifizieren",
        modifier: "-5"
      }
    ]
  }, %{
    id: 31,
    name: gettext("Malen & Zeichnen"),
    category: :crafting,
    check: {:in, :ff, :ff},
    applications: [
      %{name: gettext("Malen")},
      %{name: gettext("Ritzen")},
      %{name: gettext("Zeichnen")},
      %{name: gettext("Zauberzeichen malen"), requirement: true} # TODO
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("Farbe, Kreide, Stifte"),
    quality: gettext("Die Qualität der Zeichnung ist besser als üblich."),
    failed: gettext("Dem Held gelingt eine mit Phantasie erkennbare, aber wenig schöne Zeichnung."),
    success: gettext("Das Bild ist so gut, dass der Held für einen berühmten Maler gehalten wird."),
    botch: gettext("schreckliches, unmöglich erkennbares Gekrakel"),
    improvement_cost: :a,
    description: "Um das Gesicht eines Verdächtigen zu zeichnen, eine Karte anzufertigen oder ein Gemälde zu malen, verwendet man dieses Talent.",
    reference: {gettext("Basis Regelwerk"), 211},
    examples: [
      %{
        action: "Eine schnelle Skizze eines Flüchtigen anfertigen",
        time: "10 Minuten",
        checks: "10 Proben"
      },
      %{
        action: "Eine Herde Stiere an eine Höhlenwand malen",
        time: "20 Minuten",
        checks: "beliebig viele Proben"
      },
      %{
        action: "Das Porträt eines Helden malen",
        time: "2 Stunden",
        checks: "5 Proben"
      },
      %{
        action: "Ein breitformatiges Landschaftsbild anfertigen",
        time: "1 Tag",
        checks: "4 Proben"
      }
    ]
  }, %{
    id: 32,
    name: gettext("Mechanik"),
    category: :knowledge,
    check: {:kl, :kl, :ff},
    applications: [
      %{name: gettext("Hebel")},
      %{name: gettext("Hydraulik")},
      %{name: gettext("komplexe Systeme")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("schnellere Planung"),
    failed: gettext("Die geplante Mechanik funktioniert nicht."),
    success: gettext("Der doppelte FW zählt als FP."),
    botch: gettext("Was immer der Held konstruieren wollte: Das Objekt ist gefährlich oder die Konstruktion fällt in sich zusammen. Eine Falle wird mit größtmöglichem Erfolg ausgelöst."),
    improvement_cost: :b,
    description: "Dieses Talent umfasst Kenntnisse grundlegender mechanischer Gesetze und ihrer Anwendung, beispielsweise Hebelgesetze, Reibung und schiefe Ebenen, aber auch Flaschenzug, Zahnrad und Übersetzung. Proben auf [Mechanik] können beim Bau von Fallen, Katapulten und Spieluhren anfallen. Die eigentliche Umsetzung findet allerdings über andere Talente (z.B. [Holz-] oder [Metallbearbeitung]) statt.\nDas Anwendungsgebiet [komplexe Systeme] umfasst Uhrwerke und ähnliche Mechanismen, während [Hydraulik] vor allem Pumpen und wassergetriebene Systeme umfasst. Unter [Hebel] sind alle sonstigen Mechaniken einsortiert.",
    reference: {gettext("Basis Regelwerk"), 204},
    examples: [
      %{
        action: "Planung einer Wippe",
        time: "10 Minuten",
        checks: "12 Proben"
      },
      %{
        action: "Flaschenzug planen",
        time: "1 Stunde",
        checks: "10 Proben"
      },
      %{
        action: "Planung eines Katapults",
        time: "2 Stunden",
        checks: "5 Proben"
      },
      %{
        action: "Entwicklung einer doppelkolbigen Handpumpe",
        time: "8 Stunden",
        checks: "4 Proben"
      },
      %{
        action: "Eine Belagerungswaffe im Maße eines Skorpions (eines riesigen Katapults) planen",
        time: "2 Tage",
        checks: "2 Proben"
      }
    ]
  }, %{
    id: 33,
    name: gettext("Menschenkenntnis"),
    category: :social,
    check: {:kl, :in, :ch},
    applications: [
      %{name: gettext("Lügen durchschauen")},
      %{name: gettext("Motivation erkennen")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Der Held hat einen stärkeren Verdacht, was sein Gegenüber vorhat oder warum es lügt."),
    failed: gettext("Der Held ist sich nicht sicher."),
    success: gettext("Der Held durchschaut die Person komplett."),
    botch: gettext("Der Held ist einer kompletten Fehleinschätzung aufgesessen. So könnte er beispielsweise einem Lügner wirklich alles glauben, ehrlichen Leuten hingegen kein Wort."),
    improvement_cost: :c,
    description: "„Glaube ich ihm?“ ist eine der am häufigsten gestellten Fragen jeder Rollenspielrunde. Auch wenn [Menschenkenntnis] kein Lügendetektor in Talentform ist, kann man hiermit sein Gegenüber besser einschätzen, gegebenenfalls Unwahrheiten durchschauen und sich ein Bild von den Motiven machen. Will der Karawanenführer uns in einen Hinterhalt führen, weil er gemeinsame Sache mit der Räuberbande macht? Lügt mich die Baronin an und ist sie – entgegen ihrer eigenen Aussage – verheiratet? Ist das Elixier des Alchimisten wirklich so gut, wie er sagt, obwohl er andauernd kichern muss?",
    reference: {gettext("Basis Regelwerk"), 197},
    examples: [
      %{
        action: "Held ist nicht abgelenkt und kann sich konzentrieren",
        modifier: "+1"
      },
      %{
        action: "Held ist leicht abgelenkt",
        modifier: "-1"
      },
      %{
        action: "Lügen durchschauen",
        modifier: "Vergleichsprobe (Menschenkenntnis [Lügen durchschauen, Motivation erkennen] gegen Überreden [Manipulieren])"
      }
    ]
  }, %{
    id: 34,
    name: gettext("Metallbearbeitung"),
    category: :crafting,
    check: {:ff, :ko, :kk},
    applications: [
      %{name: gettext("Feinschmiedearbeiten")},
      %{name: gettext("Grobschmiedearbeiten")},
      %{name: gettext("Metallguss")},
      %{name: gettext("Verhütten")},
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("Hammer, Amboss, Schmiedefeuer"),
    quality: gettext("Das Werkstück ist schneller fertig oder es wird eine bessere Qualität erzielt."),
    failed: gettext("Der Held kommt mit der Arbeit an dem Werkstück nicht voran."),
    success: gettext("Die Zahl der FP bei dieser Probe verdoppelt sich, der Held erhält aber mindestens 5 FP. Erschwernisse, die durch misslungene Sammelproben aufgebaut wurden, werden komplett abgebaut."),
    botch: gettext("Ein Patzer sorgt dafür, dass die angesammelten QS auf 0 sinken und keine weitere Probe für dieses Vorhaben angewandt werden kann."),
    improvement_cost: :c,
    description: "Mit diesem Talent kann man vom Verhütten des richtigen Erzes bis hin zum Gießen oder Schmieden den Umgang mit Metallen umsetzen. Dies gilt sowohl für den Bronzeguss als auch für das Schmieden von Eisen und Stahl und den deutlich filigraneren Umgang mit Gold und anderen Edelmetallen.",
    reference: {gettext("Basis Regelwerk"), 211},
    examples: [
      %{
        action: "Einen verbeulten Kürass reparieren",
        time: "10 Minuten",
        checks: "beliebig viele Proben"
      },
      %{
        action: "Aus einem Schwert eine Pflugschar schmieden",
        time: "30 Minuten",
        checks: "10 Proben"
      },
      %{
        action: "Eine komplizierte Legierung erstellen",
        time: "1 Stunde",
        checks: "3 Proben"
      },
      %{
        action: "Ein unförmiges Hufeisen anfertigen",
        time: "2 Stunden",
        checks: "5 Proben"
      },
      %{
        action: "Aus Grassodenerz Eisen gewinnen",
        time: "8 Stunden",
        checks: "4 Proben"
      },
      %{
        action: "Verarbeitung von magischen Metallen",
        time: "2 Tage",
        checks: "2 Proben"
      }
    ]
  }, %{
    id: 35,
    name: gettext("Musizieren"),
    category: :crafting,
    check: {:ch, :ff, :ko},
    applications: [
      %{name: gettext("Blasinstrumente")},
      %{name: gettext("Saiteninstrumente")},
      %{name: gettext("Trommeln")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("Musikinstrument"),
    quality: gettext("Das Publikum zeigt sich begeisterter von der Vorstellung."),
    failed: gettext("Die Melodie klingt schief."),
    success: gettext("Der Held spielt eine Melodie, der keiner widerstehen kann und die alle Zuhörer in ihren Bann zieht."),
    botch: gettext("Schreckliche, unheilvolle Töne werden dem Musikinstrument entlockt. Möglicherweise wird das Instrument dabei beschädigt. Menschen suchen das Weite oder wollen dem Musikanten das Instrument entreißen."),
    improvement_cost: :a,
    description: "Um in einer Taverne ein paar Silberstücke zu verdienen oder sich die Zeit zu vertreiben, kann der Umgang mit einem Musikinstrument nützlich sein. Besonders in der elfischen Kultur ist Musik zudem ein beliebtes Mittel der Kommunikation.",
    reference: {gettext("Basis Regelwerk"), 212},
    examples: [
      %{
        action: "Der Flöte ein paar Töne entlocken",
        modifier: "+5"
      },
      %{
        action: "Ein paar Trommeltakte vorgeben",
        modifier: "+3"
      },
      %{
        action: "Ein einfaches Lied auf der Leier vortragen",
        modifier: "+1"
      },
      %{
        action: "Mit Flötenspiel (Fertigkeitspunkte) Heller verdienen",
        modifier: "+/- 0"
      },
      %{
        action: "Straßenballade aufführen",
        modifier: "-1"
      },
      %{
        action: "Ein Orgelkonzert geben",
        modifier: "–3"
      },
      %{
        action: "Die für ihre Komplexität bekannte Khadansaga nachspielen",
        modifier: "-5"
      }
    ]
  }, %{
    id: 36,
    name: gettext("Orientierung"),
    category: :nature,
    check: {:kl, :in, :in},
    applications: [
      %{name: gettext("Sonnenstand")},
      %{name: gettext("Sternenhimmel")},
      %{name: gettext("unter Tage")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Der Held findet schneller heraus, in welche Richtung er sich bewegt."),
    failed: gettext("Der Held weiß nicht sicher, wo es langgeht."),
    success: gettext("Der Held findet den Weg ohne Schwierigkeiten selbst unter schlechtesten Bedingungen."),
    botch: gettext("Der Held hat sich komplett verlaufen und bewegt sich in die falsche Richtung, was ihm jedoch nicht bewusst ist."),
    improvement_cost: :b,
    description: "Mithilfe des Talents [Orientierung] kann ein Abenteurer anhand von Sonnenstand, Moosbewuchs, Sternenhimmel und anderen Auffälligkeiten die Himmelsrichtung bestimmen.\n[Orientierung] hilft in Städten nur bedingt. Zwar kann der Held dort die Himmelsrichtungen bestimmen, doch offenbart lediglich eine erfolgreiche Probe auf Gassenwissen, welcher Weg der kürzeste ist und welche Straße in einer Sackgasse endet.",
    reference: {gettext("Basis Regelwerk"), 200},
    examples: [
      %{
        action: "Richtungsbestimmung mit einem Südweiser",
        modifier: "+5"
      },
      %{
        action: "In einer sternenklaren Nacht den Nordstern bestimmen",
        modifier: "+3"
      },
      %{
        action: "In einer Stadt die Richtung des Hafenviertels bestimmen",
        modifier: "+1"
      },
      %{
        action: "Durch Sonnenstand Nordwesten bestimmen",
        modifier: "+/- 0"
      },
      %{
        action: "Himmelsrichtung anhand von Moosbewuchs feststellen",
        modifier: "-1"
      },
      %{
        action: "Sich im Dschungel orientieren",
        modifier: "–3"
      },
      %{
        action: "Sich im dichten Nebel orientieren",
        modifier: "-5"
      }
    ]
  }, %{
    id: 37,
    name: gettext("Pflanzenkunde"),
    category: :nature,
    check: {:kl, :ff, :ko},
    applications: [
      %{name: gettext("Giftpflanzen")},
      %{name: gettext("Heilpflanzen")},
      %{name: gettext("Nutzpflanzen")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: gettext("ja, (beim Ackerbau und Nahrung sammeln) oder nein (bei der Bestimmung von Pflanzen)"),
    tools: nil,
    quality: gettext("genauere Informationen zu einer Pflanze"),
    failed: gettext("Der Held hat keine Ahnung."),
    success: gettext("Der Held weiß alles über die Pflanze, auch besondere Wirkungen, und kann sie doppelt so lange haltbar machen wie üblich."),
    botch: gettext("Der Held verwechselt die Pflanze mit einer anderen."),
    improvement_cost: :c,
    description: "Mithilfe des Talents [Orientierung] kann ein Abenteurer anhand von Sonnenstand, Moosbewuchs, Sternenhimmel und anderen Auffälligkeiten die Himmelsrichtung bestimmen.\n[Orientierung] hilft in Städten nur bedingt. Zwar kann der Held dort die Himmelsrichtungen bestimmen, doch offenbart lediglich eine erfolgreiche Probe auf Gassenwissen, welcher Weg der kürzeste ist und welche Straße in einer Sackgasse endet.",
    reference: {gettext("Basis Regelwerk"), 200},
    examples: [
      %{
        action: "Pflanzenbestimmung",
        modifier: "je nach Pflanze"
      },
      %{
        action: "Pflanzensuche",
        modifier: "je nach Pflanze"
      },
      %{
        action: "Einen Tag lang Kräuter, Beeren und Wurzeln für die Heldengruppe zum Essen sammeln",
        modifier: "1 QS = 1 Ration"
      }
    ]
  }, %{
    id: 38,
    name: gettext("Rechnen"),
    category: :knowledge,
    check: {:kl, :kl, :in},
    applications: [
      %{name: gettext("Bruchrechnung")},
      %{name: gettext("Punktrechnung")},
      %{name: gettext("Strichrechnung")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("schnelleres Ergebnis"),
    failed: gettext("Das Ergebnis ist falsch."),
    success: gettext("Schnelle und exakte Bestimmung der Lösung"),
    botch: gettext("Das Ergebnis ist komplett falsch, der Held aber von der Richtigkeit absolut überzeugt."),
    improvement_cost: :a,
    description: "Um die Zinsen eines Darlehens richtig zu berechnen, den Schusswinkel eines Katapults richtig einzuschätzen oder die Fläche einer Tempelkuppel korrekt zu ermitteln, ist das Talent Rechnen vonnöten.",
    reference: {gettext("Basis Regelwerk"), 204},
    examples: [
      %{
        action: "Mit Händen und Füßen bis zwanzig zählen",
        modifier: "+5"
      },
      %{
        action: "Einfaches Addieren",
        modifier: "+3"
      },
      %{
        action: "Größere Mengen dividieren",
        modifier: "+1"
      },
      %{
        action: "Berechnung der Fläche einer Dukatenmünze",
        modifier: "+/- 0"
      },
      %{
        action: "Berechnung der Zinsen eines Guthabens der letzten fünfzehn Jahre",
        modifier: "-1"
      },
      %{
        action: "Schwierige Al’Gebra- und Arithmethik-Aufgaben",
        modifier: "–3"
      },
      %{
        action: "Volumenberechnung eines Schiffsrumpfes",
        modifier: "-5"
      }
    ]
  }, %{
    id: 39,
    name: gettext("Rechtskunde"),
    category: :knowledge,
    check: {:kl, :kl, :in},
    applications: [
      %{
        name: gettext("Einzelne Region"),
        selection: regions(),
        limit: 0
      },
      %{
        name: gettext("Gildenrecht"),
        requirement: true # TODO
      }
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("mehr Optionen zur Lösung eines Falls"),
    failed: gettext("Der Held hat keine Ahnung."),
    success: gettext("Der Held kennt sich mit Besonderheiten des Gesetzes aus und kann einen Plan entwickeln, es zu seinem Vorteil auszulegen."),
    botch: gettext("Die Auslegung des Gesetzes ist falsch oder der Held übersieht einen wichtigen Passus."),
    improvement_cost: :a,
    description: "Jede Region und jedes Volk hat ihr eigenes Rechtssystem. Um Recht und Gesetz von Städten, Reichen, Gilden und Kirchen zu kennen und gegebenenfalls für sich in Anspruch nehmen zu können, bedarf es dieses Talents.",
    reference: {gettext("Basis Regelwerk"), 205},
    examples: [
      %{
        action: "Für Mord erwartet mich der Henker",
        modifier: "+5"
      },
      %{
        action: "In den Tulamidenlanden wird einem Dieb die Hand abgehackt",
        modifier: "+3"
      },
      %{
        action: "Wie wird eine öffentliche Schlägerei bestraft?",
        modifier: "+1"
      },
      %{
        action: "Wer ist für den straffälligen Magier zuständig?",
        modifier: "+/- 0"
      },
      %{
        action: "Mit welcher Strafe muss ein Rosstäuscher rechnen?",
        modifier: "-1"
      },
      %{
        action: "Kann ein Mittelreicher einen horasischen Adelstitel erben?",
        modifier: "–3"
      },
      %{
        action: "Unbekannte Rechtssysteme (Strafen der Molochen für das sinnlose Zerquetschen von Krustentieren)",
        modifier: "-5"
      }
    ]
  }, %{
    id: 40,
    name: gettext("Reiten"),
    category: :physical,
    check: {:ch, :ge, :kk},
    applications: [
      %{name: gettext("Kampfmanöver")},
      %{name: gettext("Langstreckenreiten")},
      %{name: gettext("Springreiten")},
      %{name: gettext("Verfolgungsjagden")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("Reittier"),
    quality: gettext("Der Held ist schneller an seinem Ziel."),
    failed: gettext("Das Tier bewegt sich nicht oder nicht so, wie es soll."),
    success: gettext("Das Tier macht seine Sache ausgezeichnet und wie gewünscht, der Reiter hat eine weitere Aktion zur Verfügung."),
    botch: gettext("Das Tier wirft den Reiter ab und er stürzt zu Boden (siehe Seite 340, Sturzschaden)."),
    improvement_cost: :b,
    description: "Wenn man sich nicht nur auf einem Reittier festklammern will, sondern es dazu bringen möchte, das zu tun, was man möchte, ist das Talent [Reiten] erforderlich. Langsames Reiten ohne Angabe einer Richtung erfordert keine Proben. Wenn das Tier jedoch galoppiert, Pirouetten drehen oder gezielt treten oder beißen soll, werden Proben nötig.\nKomplexe Anwendungen beziehen sich bei Reiten vor allem auf extrem ungewöhnliche Reittiere wie Kampfwildschweine oder Hornechsen.",
    reference: {gettext("Basis Regelwerk"), 190},
    examples: [
      %{
        action: "Vorwärtsmanöver, Schritttempo",
        modifier: "+5"
      },
      %{
        action: "Einfacher Trab oder schnelle Fortbewegung",
        modifier: "+3"
      },
      %{
        action: "Über eine niedrige Mauer springen, gewöhnliche Befehle befolgen (Gangartwechsel, Anhalten, Rückwärtsgehen)",
        modifier: "+1"
      },
      %{
        action: "Überraschende Wendemanöver",
        modifier: "+/- 0"
      },
      %{
        action: "Ohne Zügel im Galopp reiten",
        modifier: "-1"
      },
      %{
        action: "Das Tier dazu bringen, einen ungewöhnlichen Befehl zu befolgen",
        modifier: "–3"
      },
      %{
        action: "Sprung über eine breite Schlucht",
        modifier: "-5"
      }
    ]
  }, %{
    id: 41,
    name: gettext("Sagen & Legenden"),
    category: :knowledge,
    check: {:kl, :kl, :in},
    applications: [
      %{
        name: gettext("Einzelne Region"),
        selection: regions(),
        limit: 0
      },
      %{
        name: gettext("Gildenrecht"),
        requirement: true # TODO
      }
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("mehr Details oder verschiedene Versioneneiner Geschichte"),
    failed: gettext("Der Held kennt die Legende nicht."),
    success: gettext("Der Held kann sich an viele Details der Geschichte erinnern und kennt mehrere Varianten."),
    botch: gettext("Der Held verwechselt die Geschichte mit einer anderen oder meint sich an völlig andere Details zu erinnern."),
    improvement_cost: :b,
    description: "Die verschiedenen Völker Aventuriens kennen eine Unzahl von Geschichten, Märchen und Legenden über die Vergangenheit, und in vielen steckt ein Körnchen Wahrheit. Dieses Talent ist daher vonnöten, um die Helden und Wesenheiten dieser Geschichten zu kennen und die Sagen richtig wiederzugeben. Mit diesem Talent kann auch die Darbietung einer Geschichte abgehandelt werden, beispielsweise, um herauszufinden, ob ein Geschichtenerzähler sein Publikum mit dem Erzählen eines Märchens fesselt.",
    reference: {gettext("Basis Regelwerk"), 205},
    examples: [
      %{
        action: "Ein Kindermärchen kennen",
        modifier: "+5"
      },
      %{
        action: "Legenden aus Rohals Herrschaftszeit",
        modifier: "+3"
      },
      %{
        action: "Geron den Einhändigen kennen",
        modifier: "+1"
      },
      %{
        action: "Wissen, was Geron der Einhändige in Simyala tat",
        modifier: "+/- 0"
      },
      %{
        action: "Herkunft der Thorwaler kennen",
        modifier: "-1"
      },
      %{
        action: "Legende von Aldarin kennen",
        modifier: "–3"
      },
      %{
        action: "Geschichte von Marek dem Schlitzer kennen",
        modifier: "-5"
      }
    ]
  }, %{
    id: 42,
    name: gettext("Schlösserknacken"),
    category: :crafting,
    check: {:in, :ff, :ff},
    applications: [
      %{name: gettext("Bartschlösser")},
      %{name: gettext("Kombinationsschlösser")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("Dietrich, Haarnadel, Haken"),
    quality: gettext("Das Schloss lässt sich schneller öffnen."),
    failed: gettext("Das Schloss geht nicht auf."),
    success: gettext("Das Schloss springt in Rekordzeit auf. Der Held benötigt nur die Hälfte des üblichen Zeitaufwandes."),
    botch: gettext("Der Dietrich bricht ab, die Falle wird ausgelöst oder das Schloss verklemmt sich."),
    improvement_cost: :c,
    description: "Wenn man nicht gerade mit Gewalt Türen aufstemmen oder Wände durchbrechen will, ist dieses Talent eine gute Wahl zum Bahnen eines Weges. Besonders komplexe oder verrostete Schlösser können die Probe merklich erschweren, während geeignete Dietriche statt einfacher Haarnadeln die Probe erleichtern sollten.\nAuch mechanische Fallen lassen sich mit diesem Talent entschärfen. Wenn die Probe aber in einem solchen Fall misslingt, wird die Falle ausgelöst. Das Anwendungsgebiet [Bartschloss] umfasst alle Schlösser mit einem klassischen Schlüssel mit Bart, [Kombinationsschlösser] hingegen sind z.B. Tresore.",
    reference: {gettext("Basis Regelwerk"), 212},
    examples: [
      %{
        action: "Ein einfaches Schloss knacken",
        time: "1 Sekunde",
        checks: "10 Proben"
      },
      %{
        action: "Ein kompliziertes Schloss knacken",
        time: "5 Sekunden",
        checks: "5 Proben"
      },
      %{
        action: "Eine mehrfach gesicherte Tür öffnen",
        time: "15 Sekunden",
        checks: "4 Proben"
      },
      %{
        action: "Eine komplexe Trittfalle in einem echsischen Grabmal entschärfen",
        time: "5 Minuten",
        checks: "3 Proben"
      },
      %{
        action: "Einen zwergischen Tresor mit Kombinationsschloss knacken",
        time: "10 Minuten",
        checks: "2 Proben"
      }
    ]
  }, %{
    id: 43,
    name: gettext("Schwimmen"),
    category: :physical,
    check: {:ge, :ko, :kk},
    applications: [
      %{name: gettext("Kampfmanöver")},
      %{name: gettext("Langstreckenschwimmen")},
      %{name: gettext("Tauchen")},
      %{name: gettext("Verfolgungsjagden")},
      %{name: gettext("Wassertreten")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Der Held ist schneller an seinem Ziel."),
    failed: gettext("Der Held traut sich nicht zu schwimmen oder kommt nicht sonderlich weit – auf jeden Fall nicht bis dahin, wohin er wollte."),
    success: gettext("Der Held schwimmt die Strecke in Bestzeit. Für Qualitätsstufen, Vergleichs- und Sammelproben gilt: FP = doppelter FW."),
    botch: gettext("Der Held geht unter (siehe Seite 340ff., Erstickungsschaden). Grund dafür könnte ein Wadenkrampf sein."),
    improvement_cost: :b,
    description: "Will der Held tauchen, einen anderen aus dem Wasser ziehen, unter Wasser kämpfen oder möglichst schnell zu einem Ort hin- oder von einem Kraken wegschwimmen, ist eine Probe auf [Schwimmen] nötig. Starke Strömung und andere widrige Umstände können die Probe erschweren.",
    reference: {gettext("Basis Regelwerk"), 190},
    examples: [
      %{
        action: "In flachem Wasser zurück zum Strand gelangen",
        modifier: "+5"
      },
      %{
        action: "Wassertreten",
        modifier: "+3"
      },
      %{
        action: "Kurze Strecke zurücklegen",
        modifier: "+1"
      },
      %{
        action: "Nach einer Münze in vier Schritt Tiefe tauchen",
        modifier: "+/- 0"
      },
      %{
        action: "Unter Wasser kämpfen und gleichzeitig schwimmen",
        modifier: "-1"
      },
      %{
        action: "Einen Bewusstlosen aus dem Wasser holen",
        modifier: "–3"
      },
      %{
        action: "Gegen eine starke Brandung zum Strand schwimmen",
        modifier: "-5"
      }
    ]
  }, %{
    id: 44,
    name: gettext("Selbstbeherrschung"),
    category: :physical,
    check: {:mu, :mu, :ko},
    applications: [
      %{name: gettext("Folter widerstehen")},
      %{name: gettext("Handlungsfähigkeit bewahren")},
      %{name: gettext("Störungen ignorieren")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Die Selbstbeherrschung hält für einen längeren Zeitraum."),
    failed: gettext("Dem Helden gelingt es nicht, den Schmerz zu unterdrücken oder die Ablenkung zu ignorieren."),
    success: gettext("Es gelingt dem Helden, Schmerzen (bis Stufe III) und Ablenkungen einen ganzen Tag lang zu ignorieren."),
    botch: gettext("Der Held erhält für die nächste Stunde 2 Stufen des Zustands Schmerz oder ist durch die Ablenkung Überrascht."),
    improvement_cost: :d,
    description: "Das Talent [Selbstbeherrschung] umfasst u.a. die Befähigung, großen Schmerzen zu widerstehen, ob durch Verletzungen im Kampf oder bei einem Gewaltmarsch. Auch Ablenkungen können damit ignoriert werden, sodass sich ein Zauberer beispielsweise trotz Steine werfender Goblins weiterhin auf seinen Kampfzauber konzentrieren kann.\nMehr zu Schmerzen und anderen Zuständen siehe Kapitel Grundregeln auf Seite 31.",
    reference: {gettext("Basis Regelwerk"), 190},
    examples: [
      %{
        action: "Barfuß auf einen spitzen Stein treten, ohne zu schreien",
        modifier: "+5"
      },
      %{
        action: "Ablenkung durch kleine, geworfene Kieselsteine ignorieren",
        modifier: "+3"
      },
      %{
        action: "Sich pochenden Zahnschmerz nicht anmerken lassen",
        modifier: "+1"
      },
      %{
        action: "Zaubern auf schwankendem Schiff",
        modifier: "+/- 0"
      },
      %{
        action: "Ertragen des Bohrens in einer Wunde",
        modifier: "-1"
      },
      %{
        action: "Liturgie wirken im freien Fall",
        modifier: "–3"
      },
      %{
        action: "Bewusstsein behalten, wenn Zahnwurzel gezogen wird",
        modifier: "-5"
      }
    ]
  }, %{
    id: 45,
    name: gettext("Singen"),
    category: :physical,
    check: {:kl, :ch, :ko},
    applications: [
      %{name: gettext("Bardenballade")},
      %{name: gettext("Choral")},
      %{name: gettext("Chorgesang")},
      %{name: gettext("Sprechgesang")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: gettext("nein, eventuell ja bei Helmen"),
    tools: nil,
    quality: gettext("Der Gesang ist so gut, dass der Held mehr Applaus durch die Zuhörer erhält."),
    failed: gettext("Der Held vergisst den Text oder sein Auftritt gerät eher schlecht als recht."),
    success: gettext("Der Gesang des Helden ist noch in vielen Wochen Thema seiner Zuhörer. Hat der Held sich um Geld bemüht, dann nimmt er mindestens das Doppelte ein als üblich. Für Qualitätsstufen, Vergleichs- und Sammelproben gilt: FP = doppelter FW."),
    botch: gettext("Der Held liegt mehrere Halbtöne daneben oder vergeigt den Rhythmus. Das Lied ist eine Qual für jeden Zuhörer, der Held wird ausgebuht."),
    improvement_cost: :a,
    description: "Zwar mag eine schöne Singstimme beim [Singen] helfen, aber mit dem richtigen Maß an Übung kann fast jeder ein Lied anstimmen, ob als Heldenepos, im Tempel oder als Schlaflied an der Wiege.",
    reference: {gettext("Basis Regelwerk"), 191},
    examples: [
      %{
        action: "Mit Zechkumpanen ein Lied trällern",
        modifier: "+5"
      },
      %{
        action: "Ein Gutenachtlied anstimmen",
        modifier: "+3"
      },
      %{
        action: "Einen müden Troll in den Schlaf singen",
        modifier: "+1"
      },
      %{
        action: "Mit einem schönen Lied (Anzahl der Fertigkeitspunkte) Heller in der Taverne verdienen",
        modifier: "+/- 0"
      },
      %{
        action: "Im Tempelchor einen Choral mitsingen",
        modifier: "-1"
      },
      %{
        action: "Eine erinnerungswürdige Ballade vortragen",
        modifier: "–3"
      },
      %{
        action: "Eine Arie in einer Vinsalter Oper singen",
        modifier: "-5"
      }
    ]
  }, %{
    id: 46,
    name: gettext("Sinnesschärfe"),
    category: :physical,
    check: {:kl, :in, :in},
    applications: [
      %{name: gettext("Hinterhalt entdecken")},
      %{name: gettext("Suchen")},
      %{name: gettext("Wahrnehmen")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: gettext("nein, eventuell ja bei Helmen, Panzerhandschuhen o.Ä."),
    tools: nil,
    quality: gettext("Der Held bemerkt weitere Details."),
    failed: gettext("Der Held bemerkt nichts."),
    success: gettext("Der Held nimmt sogar kaum bemerkbare Details wahr. Für Qualitätsstufen, Vergleichs- und Sammelproben gilt: FP = doppelter FW."),
    botch: gettext("Der Held nimmt etwas anderes wahr, als das, was wirklich wichtig wäre. Er könnte zum Beispiel die in der Nähe befindlichen Blumen riechen, dafür aber nicht den auffällig stinkenden Oger, der an ihn heranschleicht."),
    improvement_cost: :d,
    description: "Das Talent [Sinnesschärfe] umfasst alle Fälle, in denen die genaue Wahrnehmung der Helden vonnöten ist. Misslungene Proben bedeuten entweder, dass der Held nichts bemerkt hat, oder dass er den Sinneseindruck falsch interpretiert. Proben auf Sinnesschärfe können vom Meister für die Spieler gewürfelt werden, um herauszufinden, ob die Helden eine versteckte Person oder ein verborgenes Detail bemerken, ohne dass den Spielern im Falle einer misslungenen Probe der Verdacht kommt, dass sie etwas übersehen haben. Das [Durchsuchen] von Räumen ist ein gezielter Vorgang, während [Wahrnehmen] intuitiv erfolgt. Proben auf dieses Talent sollten verdeckt gewürfelt werden. Beim Ertasten wird die Probe in der Regel auf KL/IN/FF abgelegt.",
    reference: {gettext("Basis Regelwerk"), 191},
    examples: [
      %{
        action: "Lautes Schreien im Nebenzimmer hören",
        modifier: "+5"
      },
      %{
        action: "Den Duft eines starken Parfüms bemerken",
        modifier: "+3"
      },
      %{
        action: "Zutaten in einer Suppe bestimmen",
        modifier: "+1"
      },
      %{
        action: "Den Duft eines leichten Parfüms bemerken",
        modifier: "+/- 0"
      },
      %{
        action: "Ein verborgenes Schriftstück in einem Zimmer finden",
        modifier: "-1"
      },
      %{
        action: "Eine Goldmünze am Grund eines Baches sehen",
        modifier: "–3"
      },
      %{
        action: "Hinterhalt bemerken",
        modifier: "Vergleichsprobe (Sinnesschärfe [Hinterhalt
        entdecken] gegen Verbergen)"
      }
    ]
  }, %{
    id: 47,
    name: gettext("Sphärenkunde"),
    category: :knowledge,
    check: {:kl, :kl, :in},
    applications: [
      %{name: gettext("Limbus")},
      %{name: gettext("nach Sphäre", limit: 0, modify: true)},
      %{name: gettext("Sphärenwesen")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("mehr Details zu Sphären oder dem Limbus"),
    failed: gettext("Der Held weiß nichts über das spezielle Thema."),
    success: gettext("Der Held erinnert sich an bemerkenswerte Details über einen einzelnen Dämon oder den Weg in eine verborgene Globule."),
    botch: gettext("Der Held unterliegt einer gefährlichen Fehleinschätzung."),
    improvement_cost: :b,
    description: "Dieses Talent beschäftigt sich mit den Geheimnissen jenseits Deres, also den sieben Sphären. Dies betrifft sowohl den Limbus, das graue Wabern zwischen den Sphären, als auch Details zu Globulen, die dämonischen Kreaturen der siebten Sphäre, die Wege ins Totenreich und die Elementarherren der zweiten Sphäre.",
    reference: {gettext("Basis Regelwerk"), 206},
    examples: [
      %{
        action: "Es gibt Dämonen",
        modifier: "+5"
      },
      %{
        action: "Es gibt Dschinne",
        modifier: "+3"
      },
      %{
        action: "Tote kommen in das Totenreich",
        modifier: "+1"
      },
      %{
        action: "Das Totenreich liegt in der vierten Sphäre",
        modifier: "+/- 0"
      },
      %{
        action: "Die Inseln im Nebel sind eine Globule",
        modifier: "-1"
      },
      %{
        action: "Man erreicht die Inseln im Nebel per Schiff",
        modifier: "–3"
      },
      %{
        action: "Die Menacoriten existieren im Limbus",
        modifier: "-5"
      }
    ]
  }, %{
    id: 49,
    name: gettext("Steinbearbeitung"),
    category: :crafting,
    check: {:ff, :ff, :kk},
    applications: [
      %{name: gettext("Maurerarbeiten")},
      %{name: gettext("Steine brechen")},
      %{name: gettext("Steinmetzarbeiten")},
      %{name: gettext("Töpferei"), requirement: true}, # TODO
      %{name: gettext("Glasbläserei"), requirement: true} # TODO
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("entsprechendes Rohmaterial (Stein, Ton), Hammer, Meißel"),
    quality: gettext("Das Werkstück ist schneller fertig oder es wird eine bessere Qualität erzielt."),
    failed: gettext("Der Held kommt mit der Arbeit an dem Werkstück nicht voran."),
    success: gettext("Die Zahl der FP bei dieser Probe verdoppelt sich, der Held erhält aber mindestens 5 FP. Erschwernisse, die durch misslungene Sammelproben aufgebaut wurden, werden komplett abgebaut."),
    botch: gettext("Ein Patzer sorgt dafür, dass die angesammelten QS auf 0 sinken und keine weitere Probe für dieses Vorhaben angewandt werden kann."),
    improvement_cost: :a,
    description: "Um Stein in die gewünschte Form zu bringen, muss man ihn spalten, behauen und zu einer Mauer verfugen. Oder man verwendet sogar die geheime zwergische Kunst des Steingusses. Ob die Steinklinge eines Fjarningers, der Wasserspeier auf einem Tempeldach oder die Mauer einer Burg, all dies ist mit dem Talent [Steinbearbeitung] geformt worden.",
    reference: {gettext("Basis Regelwerk"), 212},
    examples: [
      %{
        action: "Einen Steinkeil bearbeiten",
        time: "10 Minuten",
        checks: "beliebig viele Proben"
      },
      %{
        action: "Aus einer Feuersteinknolle eine Speerspitze herausarbeiten",
        time: "20 Minuten",
        checks: "10 Proben"
      },
      %{
        action: "Eine Amphore aus Ton formen",
        time: "30 Minuten",
        checks: "5 Proben"
      },
      %{
        action: "Eine stabile Bruchsteinmauer hochziehen",
        time: "4 Stunden",
        checks: "4 Proben"
      },
      %{
        action: "Aus Marmor eine Statue hauen",
        time: "8 Stunden",
        checks: "3 Proben"
      }
    ]
  }, %{
    id: 50,
    name: gettext("Sternkunde"),
    category: :knowledge,
    check: {:kl, :kl, :in},
    applications: [
      %{name: gettext("Astrologie")},
      %{name: gettext("Himmelskartographie")},
      %{name: gettext("Kalendarium")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("schnellere Horoskoperstellung"),
    failed: gettext("Der Held hat keine Ahnung."),
    success: gettext("Der Held kann sehr genau die Bewegungen der Himmelskörper berechnen."),
    botch: gettext("Eine Fehleinschätzung bei einem Horoskop, einer Mondfinsternis etc."),
    improvement_cost: :a,
    description: "Sowohl die alte Kunst der Astrologie als auch die Navigation und die Kalender- und Zeitbestimmung nach den Gestirnen und die Beobachtung und Katalogisierung von Himmelsphänomenen fallen unter dieses Talent.",
    note: gettext("Da nicht alle Aventurier sich mit dem Sternenhimmel auskennen, sollte der Einsatz des Talents bei den meisten Helden zunächst erschwert sein (siehe auch Ungewohnter Einsatz von Talenten auf Seite 184)."),
    reference: {gettext("Basis Regelwerk"), 206},
    examples: [
      %{
        action: "Wofür steht ein Sternzeichen?",
        modifier: "+5"
      },
      %{
        action: "Das eigene Sternbild erkennen",
        modifier: "+3"
      },
      %{
        action: "Die Wandelsterne aufzählen können",
        modifier: "+1"
      },
      %{
        action: "Horoskop erstellen",
        modifier: "+/- 0"
      },
      %{
        action: "Am Nachthimmel die Himmelsrichtungen ablesen",
        modifier: "-1"
      },
      %{
        action: "Wann ist die nächste Mondfinsternis?",
        modifier: "–3"
      },
      %{
        action: "Komplexe Karte des Sternenhimmels erstellen",
        modifier: "-5"
      }
    ]
  }, %{
    id: 51,
    name: gettext("Stoffbearbeitung"),
    category: :crafting,
    check: {:kl, :ff, :ff},
    applications: [
      %{name: gettext("Färben")},
      %{name: gettext("Filzen")},
      %{name: gettext("Schneidern")},
      %{name: gettext("Spinnen")},
      %{name: gettext("Weben")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("Messer, Nähzeug, Schere, Webstuhl"),
    quality: gettext("Das Werkstück ist schneller fertig oder es wird eine bessere Qualität erzielt."),
    failed: gettext("Der Held kommt mit der Arbeit an dem Werkstück nicht voran."),
    success: gettext("Die Zahl der FP bei dieser Probe verdoppelt sich, der Held erhält aber mindestens 5 FP. Erschwernisse, die durch misslungene Sammelproben aufgebaut wurden, werden komplett abgebaut."),
    botch: gettext("Ein Patzer sorgt dafür, dass die angesammelten QS auf 0 sinken und keine weitere Probe für dieses Vorhaben angewandt werden kann."),
    improvement_cost: :a,
    description: "Ob Spinnen und Weben, Filzen oder sogar Häkeln und Stricken, mit diesem Talent kann man nicht nur Textilien herstellen, sondern auch Kleidung vernähen. Während das Flicken eines Hemdes oder das Schneidern eines Umhangs allerhöchstens eine einfache Probe erfordern, kann das Schneidern eines Ballkleides oder das Spinnen von Seide deutlich schwieriger werden.\nDas Talent kann man außerdem zum Färben von Stoffen anwenden (die Farbe selbst wird aber mittels [Alchimie] hergestellt).",
    reference: {gettext("Basis Regelwerk"), 212},
    examples: [
      %{
        action: "Einen Riss am Hemdärmel zunähen",
        time: "10 Minuten",
        checks: "beliebig viele Proben"
      },
      %{
        action: "Wolle spinnen",
        time: "30 Minuten",
        checks: "5 Proben"
      },
      %{
        action: "Eine Hose aus Leinen schneidern",
        time: "1 Stunde",
        checks: "4 Proben"
      },
      %{
        action: "Einen hübschen Filzhut herstellen",
        time: "2 Stunden",
        checks: "4 Proben"
      },
      %{
        action: "Ein zerrissenes Brokatkleid flicken",
        time: "4 Stunden",
        checks: "3 Proben"
      },
      %{
        action: "Ein horasisches Ballkleid nähen",
        time: "1 Tag",
        checks: "2 Proben"
      }
    ]
  }, %{
    id: 52,
    name: gettext("Tanzen"),
    category: :physical,
    check: {:kl, :ch, :ge},
    applications: [
      %{name: gettext("Dorftanz")},
      %{name: gettext("exotischer Tanz")},
      %{name: gettext("Hoftanz")},
      %{name: gettext("Kulttanz")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Der Tanz ist so gut, dass der Held mehr Applaus erhält."),
    failed: gettext("Der Held bringt die Tanzschritte durcheinander."),
    success: gettext("Die Aufmerksamkeit der Zuschauer fällt wegen des perfekten Tanzes auf den Helden. Für Qualitätsstufen, Vergleichs- und Sammelproben gilt: FP = doppelter FW."),
    botch: gettext("Der Held tritt seiner Tanzpartnerin auf die Füße und verletzt sie dabei oder er stürzt und blamiert sich."),
    improvement_cost: :a,
    description: "Auf höfischen Bällen, Hexennächten und bäuerlichen Feiern kann es sehr hilfreich sein, zu wissen, wie man richtig tanzt. Besonders bei komplizierteren Gruppen- und Paartänzen ist eine Probe auf dieses Talent nötig, während eine Puniner Polonaise auch noch im volltrunkenen Zustand absolviert werden kann.",
    reference: {gettext("Basis Regelwerk"), 192},
    examples: [
      %{
        action: "Ein einfacher Bauerntanz",
        modifier: "+5"
      },
      %{
        action: "Ein tsagefälliger Ausdruckstanz im Tempel",
        modifier: "+3"
      },
      %{
        action: "Ein ritueller Tanz zu Ehren Efferds",
        modifier: "+1"
      },
      %{
        action: "Ein ekstatischer Hexentanz",
        modifier: "+/- 0"
      },
      %{
        action: "Ein höfischer Tanz auf einem Maskenball",
        modifier: "-1"
      },
      %{
        action: "Ein beeindruckender Bühnentanz",
        modifier: "–3"
      },
      %{
        action: "Ein meisterlicher erotischer Schleiertanz",
        modifier: "-5"
      }
    ]
  }, %{
    id: 53,
    name: gettext("Taschendiebstahl"),
    category: :physical,
    check: {:mu, :ff, :ge},
    applications: [
      %{name: gettext("Ablenkungen")},
      %{name: gettext("Person bestehlen")},
      %{name: gettext("Gegenstand entwenden")},
      %{name: gettext("Zustecken")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("eventuell Messer oder Dolch"),
    quality: gettext("Der Taschendiebstahl wird später bemerkt."),
    failed: gettext("Der Versuch misslingt oder das Opfer bemerkt den Diebstahl."),
    success: gettext("Das Opfer hat den Diebstahlversuch nicht bemerkt und der Held hat besonders wertvolle Beute gemacht oder gleich mehrere Ziele bestohlen. Für Qualitätsstufen, Vergleichs- und Sammelproben gilt: FP = doppelter FW."),
    botch: gettext("Der Held wird von umstehenden Personen oder dem Opfer beobachtet, ohne es zu bemerken, und der Diebstahlversuch misslingt. Außerdem ist er Überrascht."),
    improvement_cost: :b,
    description: "Mittels [Taschendiebstahl] kann ein Held die Börse seines Opfers ungesehen entwenden oder ein Loch in dessen Beutel schneiden, sodass er an eine hübsche Anzahl Münzen gelangt. Auch kleine Gegenstände, wie am Körper getragene Schlüssel oder Amulette, können so entwendet werden. Dabei gibt es einige Unterschiede in der Art und Weise des Diebstahls: Während der gemeine Taschendieb vor allem [Personen bestiehlt] und von ihrer Geldkatze erleichtert, kann der Einbrecher auch [Gegenstände entwenden], die in Schubladen, Kommoden oder anderen Aufbewahrungsorten lagern. [Ablenkungen] sind ebenfalls wichtig für das Diebeshandwerk, und ab und an muss auch ein Gegenstand jemand anderem zugesteckt werden.\nDichtes Gedränge und offen am Gürtel hängende Geldbeutel können die Probe erleichtern, während aufmerksame Wachen und mehrere Schichten Kleidung einen Diebstahl erschweren können. Die Probe wird stets als Vergleichsprobe [Taschendiebstahl (Anwendungsgebiet je nach Handlung)] gegen die [Sinnesschärfe (Wahrnehmen)] des Opfers gewürfelt. Die Probe auf Sinnesschärfe (Wahrnehmen) kann durch Ablenkung, Gedränge und Lärm erschwert oder durch erhöhte Wachsamkeit oder ruhige Umgebung erleichtert werden.",
    reference: {gettext("Basis Regelwerk"), 192},
    examples: [
      %{
        action: "offen herumliegender Geldbeutel",
        modifier: "+5"
      },
      %{
        action: "offen am Gürtel hängende Geldkatze",
        modifier: "+3"
      },
      %{
        action: "Geldsäckchen in weiter, leichter Kleidung",
        modifier: "+1"
      },
      %{
        action: "Einem Opfer auf der Straße etwas stehlen",
        modifier: "+/- 0"
      },
      %{
        action: "Schwierige Umgebung mit wenigen Versteckmöglichkeiten",
        modifier: "-1"
      },
      %{
        action: "Ring vom Finger stehlen",
        modifier: "–3"
      },
      %{
        action: "verschlossene Tasche unter dichter Kleidung öffnen",
        modifier: "-5"
      }
    ]
  }, %{
    id: 54,
    name: gettext("Tierkunde"),
    category: :nature,
    check: {:mu, :mu, :ch},
    applications: [
      %{name: gettext("domestizierte Tiere")},
      %{name: gettext("Ungeheuer")},
      %{name: gettext("Wildtiere")}
    ],
    uses: [gettext("Tierstimmen imitieren")],
    encumbrance: true,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("genauere Informationen zu einem Tier"),
    failed: gettext("Der Held hat keine Ahnung."),
    success: gettext("Der Held weiß alles über das Tier."),
    botch: gettext("Der Held glaubt, etwas über das Tier zu wissen, liegt aber gefährlich falsch (schätzt es ungiftig ein, obwohl es sehr giftig ist, oder als Pflanzenfresser, obwohl es Fleischfresser ist)."),
    improvement_cost: :c,
    description: "Im Umgang mit Tieren, bei ihrer Aufzucht und Abrichtung, aber auch bei der Jagd sind Kenntnisse über Verbreitung, Verhalten, Anatomie und Ernährung von Tierarten sehr nützlich. Durch den Vergleich mit vertrauten Arten lassen sich unbekannte Tiere einschätzen. Für Wassertiere muss das Talent [Fischen & Angeln] benutzt werden.\n\nMittels Tierkunde können nur domestizierte Tiere abgerichtet werden.",
    note: gettext("Mittels Tierkunde können nur domestizierte Tiere abgerichtet werden."),
    reference: {gettext("Basis Regelwerk"), 200},
    examples: [
      %{
        action: "Tierverhalten bestimmen",
        modifier: "je nach Tier"
      },
      %{
        action: "Einen Tag lang Frösche, Schnecken und Regenwürmer für die Heldengruppe zum Essen sammeln",
        modifier: "1 QS = 1 Ration"
      }
    ]
  }, %{
    id: 55,
    name: gettext("Überreden"),
    category: :social,
    check: {:mu, :in, :ch},
    applications: [
      %{name: gettext("Aufschwatzen")},
      %{name: gettext("Betteln")},
      %{name: gettext("Herausreden")},
      %{name: gettext("Manipulieren")},
      %{name: gettext("Schmeicheln")}
    ],
    uses: [gettext("Anführer")],
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Das Gegenüber ist bereit, mehr für den Helden zu tun."),
    failed: gettext("Dem Held gelingt es nicht, sein Gegenüber zu überreden."),
    success: gettext("Die Person, die der Held überreden wollte, tut weit mehr als sie muss."),
    botch: gettext("Die Person, die der Held überreden wollte, ist wütend auf den Helden und lässt sich in nächster Zeit nicht mehr überreden."),
    improvement_cost: :c,
    description: "Eine güldene Zunge, Wortwitz, gute Argumente – all dies zeichnet Überredungskünstler aus. Oft wird das Talent zum Lügen oder Schmeicheln verwendet.\nZwar gehen Helden nur selten der Bettelei nach, doch um eine Patrizierin zu überzeugen, ein paar Kreuzer in den Almosenbeutel des Habenichts zu werfen, werden ebenfalls Proben auf [Überreden (Betteln)] eingesetzt.",
    reference: {gettext("Basis Regelwerk"), 197},
    examples: [
      %{
        action: "Einer eitlen Person schmeicheln",
        modifier: "+5"
      },
      %{
        action: "(Fertigkeitspunkte) Kreuzer erbetteln",
        modifier: "+3"
      },
      %{
        action: "Eine schwer zu beweisende Lüge auftischen",
        modifier: "+1"
      },
      %{
        action: "Eine Schmeichelei oder Lüge vortragen",
        modifier: "+/- 0"
      },
      %{
        action: "Die Stadtwache von der eigenen Unschuld überzeugen (nachts trotz Verbots auf der Straße unterwegs)",
        modifier: "-1"
      },
      %{
        action: "Erfolgreich leugnen, die Person auf dem Steckbrief zu sein",
        modifier: "–3"
      },
      %{
        action: "Die Stadtwache von seiner Unschuld überzeugen (mit Einbruchswerkzeug in einem fremden Haus erwischt worden)",
        modifier: "-5"
      }
    ]
  }, %{
    id: 56,
    name: gettext("Verbergen"),
    category: :physical,
    check: {:mu, :in, :ge},
    applications: [
      %{name: gettext("Gegenstände verbergen")},
      %{name: gettext("Schleichen")},
      %{name: gettext("sich Verstecken")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Der Held kann schwieriger entdeckt werden oder findet schneller ein Versteck."),
    failed: gettext("Der Held hat sich nur dürftig versteckt oder Geräusche beim Schleichen verursacht."),
    success: gettext("Der Held hat ein perfektes Versteck gefunden oder ist lautlos wie eine Katze. Für Qualitätsstufen, Vergleichs- und Sammelproben gilt: FP = doppelter FW."),
    botch: gettext("Irgendetwas (Teller, ein Möbelstück) ist umgefallen."),
    improvement_cost: :c,
    description: "Wenn es gilt, sich anzuschleichen oder zu verstecken, wird auf Verbergen gewürfelt. Dunkelheit, schwarze Kleidung und gute Deckung, aber auch Lärm oder Ablenkungen potenzieller Beobachter können die Probe erleichtern, während gewarnte Wachen oder dürres Reisig auf dem Boden Verstecken und Schleichen erschweren können. In einem völlig leeren und gut ausgeleuchteten Raum kann sich jedoch selbst ein Meister des Verbergens nicht verstecken.",
    reference: {gettext("Basis Regelwerk"), 193},
    examples: [
      %{
        action: "Unentdeckt bleiben",
        modifier: "Vergleichsprobe (Verbergen [Schleichen oder sich Verstecken] gegen Sinnesschärfe [Suchen oder Wahrnehmen])"
      }
    ]
  }, %{
    id: 57,
    name: gettext("Verkleiden"),
    category: :social,
    check: {:in, :ch, :ge},
    applications: [
      %{name: gettext("Bühnenschauspiel")},
      %{name: gettext("Kostümierung")},
      %{name: gettext("Personen imitieren")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Die Verkleidung ist schwerer zu durchschauen."),
    failed: gettext("Die Verkleidung ist nicht gut gewählt und hält einem prüfenden Blick nicht stand."),
    success: gettext("Die Verkleidung funktioniert tadellos."),
    botch: gettext("Die Kleidung wird sofort durchschaut und der Held handelt sich in der Regel Ärger ein."),
    improvement_cost: :b,
    description: "In einigen Situationen kann es ratsam sein, als jemand anderes zu erscheinen. Vielleicht will ein von der Garde gesuchter Abenteurer als Bettler das Stadttor passieren oder ein Hochstapler als Grafensohn getarnt auf einem Bankett auftreten, um unbemerkt ein Diadem stehlen zu können. Um die Täuschung aufrechtzuerhalten, muss dem Helden eine Probe auf [Verkleiden (Kostümierung)] gelingen.\n[Verkleiden] umfasst aber nicht nur die Verkleidung an sich, sondern auch notwendige Gesten und Mimik. Jede erfolgreiche Theaterschauspielerin verfügt über einen hohen Wert in diesem Talent, um die verschiedenen Rollen auf der Bühne gekonnt spielen zu können. Und wer bewusst jemand anderen imitieren will, der greift ebenfalls auf [Verkleiden] zurück.\nEs ist möglich, sich als Angehöriger eines anderen Standes zu verkleiden, oder als Angehöriger eines fernen Reiches – ja, sogar eine andere Spezies und/ oder ein anderes Geschlecht lassen sich vortäuschen. Dem Talent sind jedoch gewisse Grenzen gesetzt: Ein Zwerg kann sich nicht glaubhaft als riesiger Thorwaler verkleiden, ebenso wird es für einen dicken Tulamiden schier ein Ding der Unmöglichkeit sein, sich als zierliche Elfe auszugeben.",
    reference: {gettext("Basis Regelwerk"), 198},
    examples: [
      %{
        action: "Bettler gibt sich als anderer Bettler aus",
        modifier: "+5"
      },
      %{
        action: "Almadanerin spielt eine Horasierin",
        modifier: "+3"
      },
      %{
        action: "Männlicher Hofkünstler mit femininen Zügen stellt eine Hofkünstlerin dar",
        modifier: "+1"
      },
      %{
        action: "Thorwaler imitiert einen Tulamiden",
        modifier: "+/- 0"
      },
      %{
        action: "Mann verkleidet sich als Frau oder andersherum",
        modifier: "-1"
      },
      %{
        action: "Zwerg verkörpert einen kleinen Menschen",
        modifier: "–3"
      },
      %{
        action: "Mensch tarnt sich als Ork",
        modifier: "-5"
      },
      %{
        action: "Verkleiden",
        modifier: "Vergleichsprobe (Verkleiden [Kostümierung] gegen Sinnesschärfe [Suchen oder Wahrnehmen]"
      }
    ]
  }, %{
    id: 58,
    name: gettext("Wildnisleben"),
    category: :nature,
    check: {:mu, :ge, :ko},
    applications: [
      %{name: gettext("Feuermachen")},
      %{name: gettext("Lageraufbau")},
      %{name: gettext("Lagersuche")},
      %{name: gettext("Wettervorhersage", requirement: true)} # TODO
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("eventuell Zelt, Wildnisausrüstung"),
    quality: gettext("Der Held benötigt nicht so lange, um ein Lager zu finden oder aufzubauen."),
    failed: gettext("Der Lagerplatz ist schlecht gewählt. Die Regeneration ist um 1 gesenkt."),
    success: gettext("Ein phantastischer Schlafplatz! Die Regeneration ist um 1 Punkt erhöht."),
    botch: gettext("Das Lager wird überschwemmt oder von Ungeziefer heimgesucht."),
    improvement_cost: :c,
    description: "Unter [Wildnisleben] sind alle wichtigen Tätigkeiten gefasst, die zum Überleben unter freiem Himmel wichtig sind und nicht explizit durch die übrigen Naturtalente abgedeckt sind: das Suchen eines geeigneten Lagers, das Herrichten und Befestigen der Schlafstätte, Brennmaterial sammeln und ein Feuer entfachen.\nEine Probe kann dazu dienen, das Wetter der nächsten Stunden oder Tage zu bestimmen, um somit Dauerregen oder Sandstürmen aus dem Weg zu gehen.",
    reference: {gettext("Basis Regelwerk"), 201},
    examples: [
      %{
        action: "Auf einer Wiese neben dem Dorf im Zelt nächtigen",
        modifier: "+5"
      },
      %{
        action: "Feuerholz im Wald sammeln",
        modifier: "+3"
      },
      %{
        action: "Feuermachen",
        modifier: "+1"
      },
      %{
        action: "Einen guten Lagerplatz im Wald finden",
        modifier: "+/- 0"
      },
      %{
        action: "Wird es am nächsten Tag regnen?",
        modifier: "-1"
      },
      %{
        action: "Gutes Lager in einer unwirtlichen Gegend errichten",
        modifier: "–3"
      },
      %{
        action: "Brennmaterial im Yeti-Land besorgen",
        modifier: "-5"
      }
    ]
  }, %{
    id: 59,
    name: gettext("Willenskraft"),
    category: :social,
    check: {:mu, :in, :ch},
    applications: [
      %{name: gettext("Bekehren & Überzeugen widerstehen")},
      %{name: gettext("Bedrohungen standhalten")},
      %{name: gettext("Betören widerstehen")},
      %{name: gettext("Einschüchtern widerstehen")},
      %{name: gettext("Überreden widerstehen")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Die Auswirkungen von Verführungs- oder Überredungsversuchen sind deutlich abgeschwächt oder es wird ihnen ganz widerstanden."),
    failed: gettext("Der Held kann nicht widerstehen."),
    success: gettext("Der Held widersteht und kann von dieser Person oder Sache in nächster Zeit nicht mehr beeinflusst werden."),
    botch: gettext("Der Held ist der Person, die ihn beeinflussen will, vollkommen verfallen oder fällt bei Anblick eines scheußlichen Dämons in Ohnmacht."),
    improvement_cost: :d,
    description: "Wenn es darum geht, Versuchungen zu widerstehen, spöttische Bemerkungen zu unterdrücken oder sich im Angesicht großer Gefahr zusammenzureißen, wird das Talent [Willenskraft] benötigt. Im Unterschied zur [Selbstbeherrschung] wird sie nicht bei körperlichen Proben zum Widerstehen eingesetzt, sondern ausschließlich bei geistiger Beeinflussung. Meist wird [Willenskraft] bei vergleichenden Proben gegen Talente wie [Betören], [Überreden], [Bekehren & Überzeugen] oder [Einschüchtern] verwendet.",
    reference: {gettext("Basis Regelwerk"), 198},
    examples: [
      %{
        action: "Held ist nicht abgelenkt und kann sich konzentrieren",
        modifier: "+1"
      },
      %{
        action: "Held ist leicht abgelenkt",
        modifier: "-1"
      },
      %{
        action: "Kontrolle bewahren",
        modifier: "Vergleichsprobe (Willenskraft [je nach Anwendungsgebiet] gegen Betören, Überreden, Bekehren & Überzeugen oder Einschüchtern)"
      }
    ]
  }, %{
    id: 60,
    name: gettext("Zechen"),
    category: :physical,
    check: {:kl, :ko, :kk},
    applications: [
      %{name: gettext("Vermeidung von Betäubung durch Rauschmittel")},
      %{name: gettext("Vermeidung von Schmerz durch Rauschmittel")},
      %{name: gettext("Vermeidung von Verwirrung durch Rauschmittel")}
    ],
    uses: nil,
    encumbrance: false,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("Der Held verträgt viel mehr als üblich."),
    failed: gettext("Der Held erhält eine Stufe des Zustands Betäubung und erwacht am nächsten Tag mit Kopfschmerzen oder anderen unliebsamen Auswirkungen seines Gelages."),
    success: gettext("Dem Helden gelingt es, bis zum bitteren Ende durchzuhalten, und trotzdem geht es ihm am nächsten Morgen blendend."),
    botch: gettext("Der Held begeht in seinem Zustand jedwede Peinlichkeit. Er zerlegt die halbe Taverne, wacht morgens nackt auf dem Markt oder in einem fremden Bett auf, plaudert Geheimnisse an den Feind aus und kann sich danach an nichts mehr erinnern."),
    improvement_cost: :a,
    description: "Bei Feiern, Vertragsabschlüssen, als Trinkspiel oder einfach, weil es geht, wird in fast ganz Aventurien Alkohol konsumiert, ob als Wein, vergorene Milch, Bier oder Branntwein. Ebenso fallen alle Arten von Rauschmitteln in den Anwendungsbereich dieses Talents. Um nicht völlig die Kontrolle über sich zu verlieren und die Kopfschmerzen, in Aventurien Wolf oder in schlimmen Fällen Werwolf genannt, zu verhindern, sind erfolgreiche Proben auf [Zechen (Vermeidung von Betäubung durch Rauschmittel)] nötig.",
    reference: {gettext("Basis Regelwerk"), 193},
    examples: [
      %{
        action: "Ein Abendbier trinken ohne Kopfschmerzen zu bekommen",
        modifier: "+5"
      },
      %{
        action: "Kleines Saufgelage überstehen",
        modifier: "+3"
      },
      %{
        action: "Nach Rauschkrautgenuss klare Wahrnehmung behalten",
        modifier: "+1"
      },
      %{
        action: "Nach sieben Korn aufrecht gehen",
        modifier: "+/- 0"
      },
      %{
        action: "Nach einem heftigen Saufgelage Kopfschmerzen am Tag danach vermeiden",
        modifier: "-1"
      },
      %{
        action: "Bei einer wüsten Orgie bei klarem Verstand bleiben",
        modifier: "–3"
      },
      %{
        action: "Sehr viel starken Schnaps (z.B. Premer Feuer) trinken, ohne sich zu übergeben",
        modifier: "-5"
      }
    ]
  }] |> Enum.map(& {&1.id, Map.put(&1, :slug, Dsa.slugify(&1.name))})

    :ets.insert(:skills, skills)
  end
end
