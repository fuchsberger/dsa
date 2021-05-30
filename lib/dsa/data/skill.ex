defmodule Dsa.Data.Skill do
  use Dsa, :schema

  alias Dsa.Type.{Check, CostFactor, SkillCategory}
  alias DsaWeb.Router.Helpers, as: Routes

  def format_algolia(skill) do
    %{
      objectID: "skill_#{skill.id}",
      name: skill.name,
      type: gettext("Skill"),
      path: Routes.page_path(DsaWeb.Endpoint, :index),
      # path: Routes.skill_path(Dsa.Endpoint, :show, skill.slug),
      description: skill.description,
      list_name: gettext("applications"),
      list_entries: skill.applications
    }
  end

  def seed do
    skills = [
      %{
        id: 1,
        name: gettext("Alchemy"),
        category: :crafting,
        check: {:mu, :kl, :ff},
        applications: [
          %{name: gettext("Alchemical Poisons")},
          %{name: gettext("Elixirs")},
          %{name: gettext("Mundane Alchemy")}
        ],
        uses: [],
        encumbrance: true,
        encumbrance_condition: nil,
        tools: gettext("alchemical laboratory"),
        quality: gettext("The potion is of better quality."),
        failed: gettext("The elixir is ruined, or an analysis fails to yield a useful result."),
        success: gettext("Identify an elixir precisely, including its Level and how long it will remain stable."),
        botch: gettext("The elixir has an unpleasant side effect."),
        improvement_cost: :c,
        description: "Mit der alten Kunst der Alchimie lassen sich sowohl wundersame Tinkturen als auch profane Substanzen wie Seifen, Glas und Porzellan, Farben und Lacke analysieren und herstellen.\nZur Herstellung von Elixieren und Tränken benötigt der Alchimist meist aufwendig aufzutreibende Grundstoffe, das richtige Rezept und ein Labor. Viele Alchimisten werden argwöhnisch betrachtet, da man befürchtet, sie könnten bei ihren verrückten Experimenten ihre Werkstätten in Brand setzen und giftige Wolken oder bestialischen Gestank produzieren.",
        reference: {"Basis Regelwerk", 206},
        examples: [
          %{
            action: "Alchimistische Erzeugnisse herstellen oder analysieren",
            modifier: "je nach Elixir"
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
        reference: {"Basis Regelwerk", 194},
        examples: [
          %{
            action: "Den Dörfler in guten Zeiten von einer Spende überzeugen",
            modifier: "+5"
          },
          %{
            action: "Einem Goblin die Gemeinsamkeiten von Firun und seinem Gott nahe bringen",
            modifier: "+3"
          },
          %{
            action: "Einen Bauern überzeugen, zusätzliche Abgaben an wenig verehrte Götter zu leisten",
            modifier: "+1"
          },
          %{
            action: "Bei einer politischen Diskussion sein rhetorisches Können beweisen",
            modifier: "+/- 0"
          },
          %{
            action: "Eine wirkungsvolle Schmähschrift anfertigen",
            modifier: "-1"
          },
          %{
            action: "Eine Gruppe von Bauern gegen den örtlichen Baron aufhetzen",
            modifier: "–3"
          },
          %{
            action: "Einen Zwerg zum Efferdkult bekehren",
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
        reference: {"Basis Regelwerk", 195},
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
        reference: {"Basis Regelwerk", 207},
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
        reference: {"Basis Regelwerk", 201},
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
        reference: {"Basis Regelwerk", 195},
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
        reference: {"Basis Regelwerk", 196},
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
        reference: {"Basis Regelwerk", 198},
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
        reference: {"Basis Regelwerk", 207},
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
        reference: {"Basis Regelwerk", 199},
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
      },












      %{
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
        reference: {"Basis Regelwerk", 198},
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
