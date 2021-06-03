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
        name: gettext("Persuasion"),
        category: :social,
        check: {:mu, :kl, :ch},
        applications: [
          %{name: gettext("Conversation")},
          %{name: gettext("Debate")},
          %{name: gettext("Oration")},
          %{name: gettext("Provocation")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("You persuade more people, or the target adheres to the new belief for a longer time."),
        failed: gettext("The target doesn’t believe the orator."),
        success: gettext("The target is completely convinced."),
        botch: gettext("The target feels insulted."),
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
        name: gettext("Seduction"),
        category: :social,
        check: {:mu, :kl, :ch},
        applications: [
          %{name: gettext("Flirting")},
          %{name: gettext("Romantic Arts")},
          %{name: gettext("Beautify")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: gettext("No, but there could be situational exceptions, like trying to seduce somebody while wearing plate armor"),
        tools: nil,
        quality: gettext("The target reacts favorably to the character."),
        failed: gettext("The character doesn’t manage to arouse the target’s interest."),
        success: gettext("The target tries to fulfill all the character’s wishes."),
        botch: gettext("The target slaps the character for being crude."),
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
        name: gettext("Sailing"),
        category: :crafting,
        check: {:ff, :ge, :kk},
        applications: [
          %{name: gettext("Chases")},
          %{name: gettext("Combat Maneuvers")},
          %{name: gettext("Long Distances")},
          %{name: gettext("Races")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Ship or boat"),
        quality: gettext("Negotiate the distance faster."),
        failed: gettext("The hero barely makes any progress with the boat or ship."),
        success: gettext("The hero uses currents and winds to sail twice as fast as expected."),
        botch: gettext("The hero falls overboard or damages an important part of the vessel."),
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
        name: gettext("Gambling"),
        category: :knowledge,
        check: {:kl, :kl, :in},
        applications: [
          %{name: gettext("Betting Games")},
          %{name: gettext("Board Games")},
          %{name: gettext("Card Games")},
          %{name: gettext("Dice Games")}
        ],
        uses: [ %{name: gettext("Cheating")}],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: gettext("Game"),
        quality: gettext("Make a smart gambit."),
        failed: gettext("Lose the game."),
        success: gettext("Win spectacularly. If playing for money, double your winnings."),
        botch: gettext("Others suspect the character of cheating, especially if they have suffered losing streaks. If playing for money, lose at least your whole stake (if not more)."),
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
        name: gettext("Intimidation"),
        category: :social,
        check: {:mu, :ch, :ch},
        applications: [
          %{name: gettext("Threats")},
          %{name: gettext("Torture")},
          %{name: gettext("Provocation")},
          %{name: gettext("Interrogation")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("The victim remains intimidated longer or reveals more than expected."),
        failed: gettext("The target ignores all insults and attempts at intimidation."),
        success: gettext("The target is utterly intimidated and won’t act against the character for the foreseeable future."),
        botch: gettext("Instead of being intimidated or insulted, the reverse happens, and the target grows angry, calm, or even amused. Alternatively, the would-be intimidator appears foolish."),
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
        name: gettext("Etiquette"),
        category: :social,
        check: {:kl, :in, :ch},
        applications: [
          %{name: gettext("Manners")},
          %{name: gettext("Rumors")},
          %{name: gettext("Small Talk")},
          %{name: gettext("Fashion")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("The hero makes a good impression and is remembered in a positive light."),
        failed: gettext("The hero forgets some important rules of etiquette and makes a bad impression."),
        success: gettext("The hero’s manners, wit, and charm are the talk of the party."),
        botch: gettext("The hero’s boorish behavior insults an important personage."),
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
        name: gettext("Tracking"),
        category: :nature,
        check: {:mu, :in, :ge},
        applications: [
          %{name: gettext("Animal Tracks")},
          %{name: gettext("Conceal Tracks")},
          %{name: gettext("Humanoid Tracks")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("Perceive more details on the trail."),
        failed: gettext("The hero cannot find a trail or doesn’t learn anything new."),
        success: gettext("As long as a trail hasn’t been completely destroyed, the hero can follow it to its end and receive more information than usual, spotting deceptions (such as covered-up tracks) at once."),
        botch: gettext("The hero mistakes the tracks and follows the wrong trail, perhaps meeting a dangerous creature or finding the wrong people."),
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
        name: gettext("Driving"),
        category: :nature,
        check: {:ch, :ff, :ko},
        applications: [
          %{name: gettext("Chases")},
          %{name: gettext("Combat Maneuvers")},
          %{name: gettext("Long Distances")},
          %{name: gettext("Races")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Vehicle"),
        quality: gettext("Negotiate the distance faster."),
        failed: gettext("The vehicle moves sluggishly, or the hero can’t set it into motion."),
        success: gettext("The vehicle makes good speed and arrives in record time."),
        botch: gettext("The vehicle suffers a broken axle or tips on its side and throws the driver, who suffers falling damage"),
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
        name: gettext("Ropes"),
        category: :nature,
        check: {:kl, :ff, :kk},
        applications: [
          %{name: gettext("Bindings")},
          %{name: gettext("Knots")},
          %{name: gettext("Tie Nets")},
          %{name: gettext("Splice Ropes")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: gettext("No (maybe with a helmet or gauntlets)"),
        tools: gettext("Rope"),
        quality: gettext("The bindings hold better and are more difficult to escape."),
        failed: gettext("The hero’s knots are poor quality and easier to escape than usual."),
        success: gettext("The hero ties a very robust knot. For QL, competitive checks, and cumulative checks, SP = 2xSR."),
        botch: gettext("The hero ties a knot that slips open in any situation. It won't keep anything secured."),
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
        name: gettext("Fishing"),
        category: :nature,
        check: {:ff, :ge, :ko},
        applications: [
          %{name: gettext("Saltwater Animals")},
          %{name: gettext("Freshwater Animals")},
          %{name: gettext("Water Monsters")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: gettext("Yes (spearfishing) or No (fishing with weirs, nets, or hooks)"),
        tools: gettext("Net, weir, spear, fishing line with hook"),
        quality: gettext("The fish are tastier than the average catch."),
        failed: gettext("The fish don’t bite, or avoid the net."),
        success: gettext("The number of rations obtained is very high. For QL, competitive checks, and cumulative checks, SP = 2xSR."),
        botch: gettext("The fisher falls into the water and loses some fishing equipment."),
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
        name: gettext("Flying"),
        category: :physical,
        check: {:mu, :in, :ge},
        applications: [
          %{name: gettext("Chases")},
          %{name: gettext("Combat Maneuvers")},
          %{name: gettext("Long-Distance Flight")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("a flying instrument"),
        quality: gettext("You can cover distances faster."),
        failed: gettext("The aerial maneuver fails and must be aborted."),
        success: gettext("The maneuver succeeds, and the hero has an additional action remaining for the round."),
        botch: gettext("The hero crashes."),
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
        name: gettext("Streetwise"),
        category: :social,
        check: {:kl, :in, :ch},
        applications: [
          %{name: gettext("Asking Around")},
          %{name: gettext("Judging Locations")},
          %{name: gettext("Shadowing")}
        ],
        uses: [],
        encumbrance: false,
        encumbrance_condition: gettext("No (maybe in some situations, such as if your armor helps you resemble a guard or a nobleman)"),
        tools: nil,
        quality: gettext("Collect more information, or get it faster than expected."),
        failed: gettext("Receive no useful information."),
        success: gettext("Find an especially good but inexpensive inn, obtain much more information than expected, or find a contact who offers excellent terms."),
        botch: gettext("Walk into an ambush by a gang of thugs who plan to rob you blind."),
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
        name: gettext("Gaukelei"),
        category: :physical,
        check: {:mu, :ch, :ff},
        applications: [
          %{name: gettext("Clowning")},
          %{name: gettext("Hiding Tricks")},
          %{name: gettext("Juggling")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Depends on the trick (balls, torches, snakes, cards, and so on)"),
        quality: gettext("Perform the trick especially well and garner more applause from the audience."),
        failed: gettext("The trick doesn’t really work due to small mistakes, and the audience is disappointed."),
        success: gettext("The audience is fascinated and thinks you’ve worked true magic. If there’s money to be earned, you earn double the normal amount."),
        botch: gettext("The audience boos the hero for a mishap during the performance (perhaps the hero hits an audience member with a juggling club, or injures the mayor with pyrotechnics, or some such)."),
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
        name: gettext("Geography"),
        category: :knowledge,
        check: {:kl, :kl, :in},
        applications: [
          %{name: gettext("Al’Anfan Empire")},
          %{name: gettext("Albernia")},
          %{name: gettext("Almada")},
          %{name: gettext("Andergast")},
          %{name: gettext("Arania")},
          %{name: gettext("Mountain Kingdoms of the Dwarves")},
          %{name: gettext("Bornland")},
          %{name: gettext("Garetia")},
          %{name: gettext("Gjalskerland")},
          %{name: gettext("High North")},
          %{name: gettext("Horasian Empire")},
          %{name: gettext("Caliphate")},
          %{name: gettext("Kosh")},
          %{name: gettext("Maraskan")},
          %{name: gettext("Northmarches")},
          %{name: gettext("Nostria")},
          %{name: gettext("Orclands")},
          %{name: gettext("Rommilysian Marches")},
          %{name: gettext("Salamander Stones & Elf Realms")},
          %{name: gettext("Shadowlands")},
          %{name: gettext("South Sea & Forest Islands")},
          %{name: gettext("Svellt Valley")},
          %{name: gettext("Thorwal")},
          %{name: gettext("Deep South")},
          %{name: gettext("Tobrien")},
          %{name: gettext("Lands of the Tulamydes")},
          %{name: gettext("Weiden")},
          %{name: gettext("Windhag")},
          %{name: gettext("Cyclops’ Islands")}
        ],
        uses: [gettext("Cartography")],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("Uncover more details about population, places, and river crossings"),
        failed: gettext("The hero has no idea."),
        success: gettext("The hero knows many details of the region, such as rulers, population count, customs, river courses, and bridges."),
        botch: gettext("Misremember geographic details completely (the population count is off, bridges are not where they were thought to be, and so on)."),
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
        name: gettext("History"),
        category: :knowledge,
        check: {:kl, :kl, :in},
        applications: [
          %{name: gettext("Al’Anfan Empire")},
          %{name: gettext("Albernia")},
          %{name: gettext("Almada")},
          %{name: gettext("Andergast")},
          %{name: gettext("Arania")},
          %{name: gettext("Mountain Kingdoms of the Dwarves")},
          %{name: gettext("Bornland")},
          %{name: gettext("Garetia")},
          %{name: gettext("Gjalskerland")},
          %{name: gettext("High North")},
          %{name: gettext("Horasian Empire")},
          %{name: gettext("Caliphate")},
          %{name: gettext("Kosh")},
          %{name: gettext("Maraskan")},
          %{name: gettext("Northmarches")},
          %{name: gettext("Nostria")},
          %{name: gettext("Orclands")},
          %{name: gettext("Rommilysian Marches")},
          %{name: gettext("Salamander Stones & Elf Realms")},
          %{name: gettext("Shadowlands")},
          %{name: gettext("South Sea & Forest Islands")},
          %{name: gettext("Svellt Valley")},
          %{name: gettext("Thorwal")},
          %{name: gettext("Deep South")},
          %{name: gettext("Tobrien")},
          %{name: gettext("Lands of the Tulamydes")},
          %{name: gettext("Weiden")},
          %{name: gettext("Windhag")},
          %{name: gettext("Cyclops’ Islands")}
        ],
        uses: nil,
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("Uncover more details about historical personalities and epochs."),
        failed: gettext("The hero has no idea."),
        success: gettext("The hero knows many details about a certain event or historical person."),
        botch: gettext("Everything you remember about the subject is incorrect; you are wrong about dates and events."),
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
        name: gettext("Religions"),
        category: :knowledge,
        check: {:kl, :kl, :in},
        applications: [
          %{name: gettext("A specific deity oder philosophy", modify: true)}
        ],
        uses: nil,
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("More details about Churches, cults, gods, and clergy."),
        failed: gettext("The hero has no idea."),
        success: gettext("The hero knows detailed information about the topic, including special rituals, prayer texts, and philosophical basics."),
        botch: gettext("Confuse special rites and philosophies of one Church for those of another."),
        improvement_cost: :b,
        description: "In einer Welt, in der Götter real sind und ihre Diener wahrhafte Wunder wirken können, ist das Wissen um Alveraniare, Halbgötter und ihre Sendboten mehr wert als Gold. Dies gilt besonders für Geweihte, die Göttersagen und das Leben der Heiligen genauso beherrschen müssen wie die richtigen Rituale und Gebete. Zu diesem Talent gehören außerdem Kenntnisse der Philosophie und fremdartiger Denkrichtungen.",
        note: gettext("If the description for a church or cult states that knowledge of the religion is a trade secret, that Church or cult cannot normally be taken as an Application of this skill. The GM has the final say."),
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
        name: gettext("Commerce"),
        category: :crafting,
        check: {:kl, :in, :ch},
        applications: [
          %{name: gettext("Accounting")},
          %{name: gettext("Haggling")},
          %{name: gettext("Money Exchange")},
          %{name: gettext("Fencing Stolen Goods"), requirement: {:mundane_ability, 1}}, # TODO: id
        ],
        uses: [gettext("Horse Faker")],
        encumbrance: false,
        encumbrance_condition: nil,
        tools: nil,
        quality: gettext("The hero can identify the price more precisely."),
        failed: gettext("The hero gets less than expected."),
        success: gettext("The hero buys goods extremely cheaply or sells them for a fortune, and avoids leaving partners feeling left out or resentful. Any resulting price hike or discount should be at least 50%."),
        botch: gettext("The other person takes advantage of you, or a business partner refuses the deal. Any disadvantageous price variation should be at least 50%."),
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
        name: gettext("Treat Poison"),
        category: :crafting,
        check: {:mu, :kl, :in},
        applications: [
          %{name: gettext("Alchemical Poisons")},
          %{name: gettext("Mineral-based Poisons")},
          %{name: gettext("Plant-based Toxins")},
          %{name: gettext("Venoms")}
        ],
        uses: nil,
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Antidote"),
        quality: gettext("Identify the poison (and therefore the treatment) faster."),
        failed: gettext("The hero can’t identify the poison and knows of no treatment."),
        success: gettext("The patient recovers without the need for a special antidote."),
        botch: gettext("The healer performs an injurious bloodletting or otherwise injures the patient, possibly worsening the poisoning (1D6 DP, ignoring PRO)."),
        improvement_cost: :b,
        description: "Um einer vergifteten Person zu helfen, muss das Gift identifiziert und eine Behandlung, beispielsweise mit einem Gegengift, vorgenommen werden. Mit einer um die Stufe des Giftes erschwerten Probe auf das Talent kann einem Patienten geholfen werden. Manche Gegenmittel erfordern jedoch seltene Ingredienzien, die erst aufwendig beschafft werden müssen. Ist das Gegenmittel verabreicht, so ist die Wirkung des Giftes gestoppt.\nScheitert die Probe, erkennt der Heiler das Gift nicht oder kennt kein geeignetes Gegenmittel.\nDas Wissen über [komplexe] Gifte erfordert ein Berufsgeheimnis.",
        note: "[Behandlung von Giften und Krankheiten]\nDurch eine gelungene Probe auf Heilkunde Gift oder Krankheiten kann ein Held das Wissen um die genaue Art des Giftes bzw. der Krankheit sowie die passende Behandlung eines Patienten in Erfahrung bringen bzw. erinnert sich an die richtige Behandlungsmethode. Behandlung bedeutet in diesem Fall, dass er alle Informationen zu den Abschnitten Behandlung und Gegenmittel erhält und sich auch entsprechend um den Patienten kümmern kann, damit dieser davon profitiert.",
        reference: {gettext("Basis Regelwerk"), 208},
        examples: nil
      }, %{
        id: 20,
        name: gettext("Treat Disease"),
        category: :crafting,
        check: {:mu, :in, :ko},
        applications: [
          %{
            name: gettext("individual diseases (such as swamp fever)"),
            modify: true,
            limit: false
          }
        ],
        uses: nil,
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Remedy"),
        quality: gettext("Identify the disease faster."),
        failed: gettext("The hero can’t identify the disease and knows of no remedy or treatment."),
        success: gettext("The patient heals without the need for a special remedy. In addition, the hero doesn’t catch the disease."),
        botch: gettext("The treatment injures the patient (1D6 DP,ignoring PRO) or the symptoms get worse. In addition, for contagious diseases, raise the chance of the hero becoming infected by 25%."),
        improvement_cost: :b,
        description: "Mit einer um die Stufe der Krankheit erschwerten Probe lassen sich die Krankheit und eine mögliche Behandlung ermitteln. In manchen Fällen sind jedoch exotische Heilmittel vonnöten, die erst beschafft werden müssen. Meist endet die Krankheit nach der Behandlung nicht abrupt, doch ihre Auswirkungen werden gemildert und die Dauer der Erkrankung verkürzt.\nDas Wissen über [komplexe] Krankheiten erfordert ein Berufsgeheimnis.",
        reference: {gettext("Basis Regelwerk"), 208},
        examples: nil
        }, %{
          id: 21,
          name: gettext("Treat Soul"),
          category: :crafting,
          check: {:in, :ch, :ko},
          applications: [
            %{name: gettext("Suppress Negative Trait")},
            %{name: gettext("Suppress Fear")},
            %{name: gettext("Suppress Personality Flaw")}
          ],
          uses: nil,
          encumbrance: false,
          encumbrance_condition: nil,
          tools: nil,
          quality: gettext("The patient suppresses the disadvantage for a longer time."),
          failed: gettext("The healer has no idea how to help the patient."),
          success: gettext("The patient suppresses a disadvantage (Afraid of…, Personality Flaw, or Negative Trait)for an entire day."),
          botch: gettext("The healer unsettles or otherwise damages the patient’s psyche. The patient suffers a level of either the condition Fear or Confusion for one day."),
          improvement_cost: :b,
          description: "Wenn der Held panische Angst vor Feuer hat, von Alpträumen verfolgt wird oder von dämonischem Wirken traumatisiert ist, sind Seelenheiler gefragt. Ein kurzes Gespräch zwischen Heiler und Patient reicht aus, um seine Nachteile zu unterdrücken: Der Seelenheilkundige kann bei gelungener Probe bei seinem Patienten eine Angst, eine Schlechte Eigenschaft oder eine Persönlichkeitsschwäche für FP in Minuten unterdrücken.\nBei einer längeren Sitzung zwischen Heiler und Patient, die mehrere Stunden dauern kann, werden die oben genannten Nachteile für Qualitätsstufe in Stunden unterdrückt.",
          reference: {gettext("Basis Regelwerk"), 209},
          examples: nil
      }, %{
        id: 22,
        name: gettext("Treat Wounds"),
        category: :crafting,
        check: {:kl, :ff, :ff},
        applications: [
          %{name: gettext("Enhance Healing")},
          %{name: gettext("Relieve Pain")},
          %{name: gettext("Stabilize")}
        ],
        uses: nil,
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("Bandages, surgical instruments, herbs, needle and thread"),
        quality: gettext("The hero requires fewer healing herbs for the skill check, or treats the wound faster."),
        failed: gettext("The hero can’t help the wounded person."),
        success: gettext("The subject receives (SP) LP during the next Regeneration Phase."),
        botch: gettext("Injure the subject during treatment (1D6 DP, ignoring PRO)."),
        improvement_cost: :d,
        description: "Verletzungen gehören für Helden zur Tagesordnung. Schnitte, Prellungen und Brüche, aber auch Zahnleiden können mit dem Talent [Heilkunde Wunden] behandelt und die Heilung damit beschleunigt werden. Der Patient erhält QS LeP bei der nächsten Regenerationsphase, zusätzlich zur normalen Regeneration. Eine solche Behandlung dauert 15 Minuten.\nAußerdem kann der Heiler dem Patienten Schmerzen nehmen, die durch LE-Verlust entstanden sind. Für je 1 QS wird eine Stufe des Zustands Schmerz ignoriert. Eine solche Behandlung dauert ebenfalls 15 Minuten. Diese Wirkung hält bis zum Ende der nächsten Regenerationsphase. Außerdem kann ein Held einen Sterbenden stabilisieren.\nDie Anwendungsgebiete [Heilung fördern] und [Schmerzen nehmen] kann ein Held auch auf sich selbst anwenden. Ein Held kann sich aber durch das Talent nicht selbst stabilisieren.",
        reference: {gettext("Basis Regelwerk"), 209},
        examples: nil
      }, %{
      id: 23,
      name: gettext("Woodworking"),
      category: :crafting,
      check: {:ff, :ge, :kk},
      applications: [
        %{name: gettext("Carpenter")},
        %{name: gettext("Felling & Cutting")},
        %{name: gettext("Joiner")}
      ],
      uses: nil,
      encumbrance: true,
      encumbrance_condition: nil,
      tools: gettext("Depends on the material being worked (for example, ax, plane, knife, saw, and so on)."),
      quality: gettext("Finish the item faster or with a better quality."),
      failed: gettext("The hero makes no progress."),
      success: gettext("The hero receives double the number of SP for the check (minimum of 5 SP). Remove all penalties accrued due to failed cumulative checks."),
      botch: gettext("Accumulated QL drop to 0 and you may make no further checks on this project."),
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
    name: gettext("Climbing"),
    category: :physical,
    check: {:mu, :ge, :kk},
    applications: [
      %{name: gettext("Ice")},
      %{name: gettext("Mountains")},
      %{name: gettext("Trees")},
      %{name: gettext("Walls")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: gettext("Climbing gear, depending on the circumstances."),
    quality: gettext("The hero reaches the destination faster."),
    failed: gettext("The climb takes longer than expected, or the hero suffers an injury (1D3 DP, ignoring PRO), doesn’t dare to climb, or gets stuck somewhere along the way."),
    success: gettext("The hero climbs much faster and safer than usual. Witnesses think the hero might be one of the best climbers on Dere. For QL, competitive checks, and cumulative checks, SP = 2xSR."),
    botch: gettext("The hero slips and falls."),
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
    name: gettext("Body Control"),
    category: :physical,
    check: {:ge, :ge, :ko},
    applications: [
      %{name: gettext("Acrobatics")},
      %{name: gettext("Balance")},
      %{name: gettext("Combat Maneuver")},
      %{name: gettext("Jumping")},
      %{name: gettext("Running")},
      %{name: gettext("Squirm")}
    ],
    uses: nil,
    encumbrance: true,
    encumbrance_condition: nil,
    tools: nil,
    quality: gettext("The adventurer can more quickly squirm out of restraints."),
    failed: gettext("The action fails partially, requires more time, or leads to mistakes, perhaps forcing the hero to abort the action."),
    success: gettext("The action succeeds and the hero still has another action remaining. Whatever was attempted, the hero looked very graceful."),
    botch: gettext("The hero falls down and suffers an injury (1D6 DP, ignoring PRO)."),
    improvement_cost: :d,
    description: "Wenn ein Held über eine Burgmauer oder an einer steilen Klippe entlangsteigt, steht eine Probe auf Klettern an. Eine misslungene Probe bedeutet nicht automatisch einen Sturz, eventuell traut sich ein Held erst gar nicht zu klettern, verletzt sich oder braucht furchtbar lange, um sein Ziel zu erreichen.",
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
