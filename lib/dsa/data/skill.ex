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
        check: {:mu, :kl, :ch},
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
        check: {:mu, :ch, :ch},
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
    improvement_cost: :d,
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




        id: 200,
        name: gettext("Animal Lore"),
        category: :nature,
        check: {:mu, :in, :ge},
        applications: [
          %{name: gettext("Domesticated Animals")},
          %{name: gettext("Monsters")},
          %{name: gettext("Wild Animals")}
        ],
        uses: [gettext("Mimicry")],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("The hero gains more information about an animal."),
        failed: gettext("The hero has no idea."),
        success: gettext("The hero has extensive knowledge of that type of animal."),
        botch: gettext("You feel confident, but everything you think you know about the animal is wrong (you think an animal isn’t dangerous even though it is highly poisonous, or you believe it is herbivorous when it is actually carnivorous)."),
        improvement_cost: :c,
        description: "Im Umgang mit Tieren, bei ihrer Aufzucht und Abrichtung, aber auch bei der Jagd sind Kenntnisse über Verbreitung, Verhalten, Anatomie und Ernährung von Tierarten sehr nützlich. Durch den Vergleich mit vertrauten Arten lassen sich unbekannte Tiere einschätzen. Für Wassertiere muss das Talent [Fischen & Angeln] benutzt werden.\n\nMittels Tierkunde können nur domestizierte Tiere abgerichtet werden.",
        reference: {gettext("Basis Regelwerk"), 198},
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
      }

    ] |> Enum.map(& {&1.id, &1})

    :ets.insert(:skills, skills)
  end
end
