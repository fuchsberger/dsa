defmodule Dsa.Data do
  use GenServer

  @name __MODULE__

  @armors [
    # {id, name, rs, be, stability, penalties}
    {1, "Normale Kleidung / Nackt", 0, 0, 4, false},
    {2, "Schwere Kleidung / Winter", 1, 0, 5, true },
    {3, "Iryanrüstung", 3, 1, 8, true },
    {4, "Kettenhemd", 4, 2, 13, false },
    {5, "Krötenhaut", 3, 1, 8, true },
    {6, "Lederharnisch", 3, 1, 8, true },
    {7, "Leichte Platte", 6, 3, 11, false },
    {8, "Schuppenpanzer", 5, 2, 12, true },
    {9, "Spiegelpanzer", 4, 2, 13, false },
    {10, "Tuchrüstung", 2, 1, 6, false }
  ]

  @combat_skills [
    # {id, sf, ranged, parade, ge, kk, name, stability}
    {1, "B", false, true, true, false, "Dolche", 14 },
    {2, "C", false, true, true, false, "Fächer", 13 },
    {3, "C", false, true, true, false, "Fechtwaffen", 8 },
    {4, "C", false, true, false, true, "Hiebwaffen", 12 },
    {5, "C", false, false, false, true, "Kettenwaffen", 10 },
    {6, "B", false, true, false, true, "Lanzen", 6 },
    {7, "B", false, false, false, false, "Peitschen", 4 },
    {8, "B", false, true, true, true, "Raufen", 12 },
    {9, "C", false, true, false, true, "Schilde", 10 },
    {10, "C", false, true, true, true, "Schwerter", 13 },
    {11, "C", false, false, false, true, "Spießwaffen", 12 },
    {12, "C", false, true, true, true, "Stangenwaffen", 12 },
    {13, "C", false, true, false, true, "Zweihandhiebwaffen", 11 },
    {14, "C", false, true, false, true, "Zweihandschwerter", 12 },
    # Ranged combat
    {15, "B", true, false, false, false, "Armbrüste", 6 },
    {16, "B", true, false, false, false, "Blasrohre", 10 },
    {17, "C", true, false, false, false, "Bögen", 4 },
    {18, "C", true, false, false, false, "Diskusse", 12 },
    {19, "B", true, false, false, false, "Feuerspeien", 20 },
    {20, "B", true, false, false, false, "Schleudern", 4 },
    {21, "B", true, false, false, false, "Wurfwaffen", 10 }
  ]

  @fweapons [
    # {id, combat_skill_id, name, tp_dice, tp_bonus, rw1, rw2, rw3, lz}
    {1, 15, "Balestrina", 1, 4, 5, 25, 40, 2},
    {2, 15, "Balläster", 1, 3, 20, 60, 100, 2},
    {3, 16, "Blasrohr", 0, 1, 5, 20, 40, 2},
    {4, 18, "Diskus", 1, 2, 5, 25, 40, 2},
    {5, 15, "Eisenwalder", 1, 4, 10, 50, 80, 2},
    {6, 17, "Elfenbogen", 1, 5, 50, 100, 200, 1},
    {7, 15, "Handarmbrust", 1, 3, 5, 25, 40, 3},
    {8, 17, "Kompositbogen", 1, 7, 20, 100, 160, 2},
    {9, 17, "Kurzbogen", 1, 4, 10, 50, 80, 1},
    {10, 17, "Langbogen", 1, 8, 20, 100, 160, 2},
    {11, 15, "Leichte Armbrust", 1, 6, 10, 50, 80, 8},
    {12, 21, "Schneidzahn", 1, 4, 2, 10, 15, 2},
    {13, 15, "Schwere Armbrust", 2, 6, 20, 100, 160, 15},
    {14, 21, "Wurfbeil", 1, 3, 2, 10, 15, 1},
    {15, 21, "Wurfdolch", 1, 1, 2, 10, 15, 1},
    {16, 21, "Wurfkeule", 1, 2, 2, 10, 15, 1},
    {17, 21, "Wurfnetz", 0, 0, 1, 3, 5, 1},
    {18, 21, "Wurfring", 1, 1, 2, 10, 15, 1},
    {19, 21, "Wurfscheibe", 1, 1, 2, 10, 15, 1},
    {20, 21, "Wurfstern", 1, 1, 2, 10, 15, 1},
    {21, 21, "Wurfspeer", 2, 2, 5, 25, 40, 2}
  ]

  @mweapons [
    # {id, combat_skill_id, name, tp_dice, tp_bonus, ge, kk, ls, at_mod, pa_mod, rw}
    {1, 10, "Amazonensäbel", 1, 4, true, true, 15, 0, 0, 2},
    {2, 14, "Anderthalbhänder", 1, 6, false, true, 14, 0, 0, 2},
    {3, 10, "Barbarenschwert", 1, 5, true, true, 15, -1, -1, 2},
    {4, 13, "Barbarenstreitaxt", 2, 4, false, true, 13, 0, -4, 2},
    {5, 1, "Basiliskenzunge", 1, 2, true, false, 14, 0, -1, 1},
    {6, 4, "Brabakbengel", 1, 5, false, true, 14, -1, -2, 2},
    {7, 10, "Breitschwert", 1, 4, true, true, 14, -1, -1, 2},
    {8, 1, "Dolch", 1, 1, true, false, 14, 0, 0, 2},
    {9, 14, "Doppelkhunchomer", 2, 3, false, true, 14, 0, -2, 2},
    {10, 1, "Drachenzahn", 1, 2, true, false, 14, 0, -1, 1},
    {11, 12, "Dreizack", 1, 4, true, true, 15, 0, 0, 3},
    {12, 12, "Dschadra", 1, 5, true, true, 15, 0, -1, 3},
    {13, 10, "Entermesser", 1, 3, true, true, 15, 0, -1, 2},
    {14, 9, "Faustschild", 1, 0, false, true, 16, -3, 0, 1},
    {15, 13, "Felsspalter", 2, 2, false, true, 13, 0, -2, 2},
    {16, 3, "Florett", 1, 3, true, false, 14, 1, 0, 2},
    {17, 7, "Fuhrmannspeitsche", 1, 0, false, false, 16, 0, 0, 3},
    {18, 12, "Glefe", 1, 5, true, true, 15, 0, -2, 3},
    {19, 14, "Großer Sklaventod", 2, 3, false, true, 14, 0, -2, 2},
    {20, 9, "Großschild", 1, 1, false, true, 16, -6, 3, 1},
    {21, 1, "Hakendolch", 1, 1, true, false, 14, -1, 0, 1},
    {22, 10, "Haumesser", 1, 3, true, true, 15, 0, -1, 2},
    {23, 12, "Hellebarde", 1, 6, true, true, 15, 0, -2, 3},
    {24, 9, "Holzschild", 1, 0, false, true, 16, -4, 1, 1},
    {25, 12, "Holzspeer", 1, 2, true, true, 15, 0, 0, 3},
    {26, 1, "Jagdmesser", 1, 1, true, false, 14, 0, -2, 1},
    {27, 12, "Jagdspieß", 1, 5, true, true, 15, 0, -1, 3},
    {28, 12, "Kampfstab", 1, 1, true, true, 15, 0, 2, 3},
    {29, 1, "Katar", 1, 1, true, false, 13, 0, -1, 1},
    {30, 4, "Keule", 1, 3, false, true, 14, 0, -1, 2},
    {31, 10, "Khunchomer", 1, 4, true, true, 15, 0, 0, 2},
    {32, 4, "Knüppel", 1, 2, false, true, 14, 0, -2, 2},
    {33, 13, "Kriegshammer", 2, 3, false, true, 13, 0, -3, 2},
    {34, 10, "Kurzschwert", 1, 2, true, true, 15, 0, 0, 1},
    {35, 10, "Langschwert", 1, 4, true, true, 15, 0, 0, 2},
    {36, 9, "Lederschild", 1, 0, false, true, 16, -4, 1, 1},
    {37, 4, "Lindwurmschläger", 1, 4, false, true, 14, 0, -1, 1},
    {38, 1, "Linkhand", 1, 1, true, false, 14, 0, 0, 1},
    {39, 4, "Magierstab (Kurz)", 1, 1, false, true, 14, 0, -1, 1},
    {40, 4, "Magierstab (Mittel)", 1, 2, false, true, 14, 0, -1, 2},
    {41, 12, "Magierstab (Lang)", 1, 2, true, true, 16, -1, 2, 3},
    {42, 1, "Mengbilar", 1, 1, true, false, 14, 0, -2, 1},
    {43, 1, "Messer", 1, 1, true, false, 14, 0, -2, 1},
    {44, 4, "Molokdeschnaja", 1, 4, false, true, 14, 0, -1, 2},
    {45, 5, "Morgenstern", 1, 5, false, true, 14, 0, 0, 2},
    {46, 10, "Nachtwind", 1, 4, true, true, 15, 0, 0, 2},
    {47, 5, "Ochsenherde", 2, 6, false, true, 14, -2, 0, 2},
    {48, 1, "Ogerfänger", 1, 2, true, false, 14, 0, -1, 1},
    {49, 5, "Ogerschelle", 2, 2, false, true, 14, -2, 0, 2},
    {50, 8, "Orchidee", 1, 2, true, true, 15, 0, -1, 1},
    {51, 4, "Orknase", 1, 5, false, true, 14, -1, -2, 2},
    {52, 8, "Panzerarm", 1, 1, true, true, 15, 0, 0, 1},
    {53, 4, "Rabenschnabel", 1, 4, false, true, 14, 0, -2, 2},
    {54, 3, "Rapier", 1, 3, true, false, 15, 1, 1, 2},
    {55, 14, "Richtschwert", 2, 6, false, true, 14, -2, -3, 2},
    {56, 10, "Robbentöter", 1, 4, true, true, 15, 0, 0, 2},
    {57, 14, "Rondrakamm", 2, 2, false, true, 14, 0, -1, 2},
    {58, 10, "Säbel", 1, 3, true, true, 15, 0, 0, 2},
    {59, 8, "Schlagring", 1, 1, true, true, 15, 0, 0, 1},
    {60, 12, "Schnitter", 1, 5, true, true, 15, -1, -1, 3},
    {61, 1, "Schwerer Dolch", 1, 2, true, false, 14, 0, -1, 1},
    {62, 10, "Sklaventod", 1, 4, true, true, 15, 0, 0, 2},
    {63, 4, "Sonnenzepter", 1, 3, false, true, 14, 0, -1, 2},
    {64, 12, "Speer", 1, 4, true, true, 15, 0, 0, 3},
    {65, 3, "Stockdegen", 1, 2, true, false, 15, 1, 0, 2},
    {66, 4, "Streitaxt", 1, 4, false, true, 14, 0, -1, 2},
    {67, 4, "Streitkolben", 1, 4, false, true, 14, 0, -1, 2},
    {68, 9, "Thorwalerschild", 1, 1, false, true, 16, -5, 2, 1},
    {69, 14, "Tuzakmesser", 1, 6, false, true, 14, 0, 0, 2},
    {70, 1, "Waqqif", 1, 2, true, false, 14, 0, -1, 1},
    {71, 13, "Warunker Hammer", 1, 6, false, true, 14, 0, -3, 2},
    {72, 3, "Wolfsmesser", 1, 4, true, false, 15, 1, 0, 2},
    {73, 14, "Zweihänder", 2, 4, false, true, 14, 0, -3, 2},
    {74, 12, "Zweililie", 1, 4, true, true, 15, 0, 2, 2},
    {75, 13, "Zwergenschlägel", 1, 6, false, true, 13, 0, -1, 2}
  ]

  @skills [
    # {id, sf, category, probe, name, be}
    # Körper (1)
    {1, "B", 1, "MU/IN/GE", "Fliegen", true },
    {2, "A", 1, "MU/CH/FF", "Gaukeleien", true },
    {3, "B", 1, "MU/GE/KK", "Klettern", true },
    {4, "D", 1, "GE/GE/KO", "Körperbeherrschung", true },
    {5, "B", 1, "KO/KK/KK", "Kraftakt", true },
    {6, "B", 1, "CH/GE/KK", "Reiten", true },
    {7, "B", 1, "GE/KO/KK", "Schwimmen", true },
    {8, "D", 1, "MU/MU/KO", "Selbstbeherrschung", false },
    {9, "A", 1, "KL/CH/KO", "Singen", nil },
    {10, "D", 1, "KL/IN/IN", "Sinnesschärfe", nil },
    {11, "A", 1, "KL/CH/GE", "Tanzen", true },
    {12, "B", 1, "MU/FF/GE", "Taschendiebstahl", true },
    {13, "C", 1, "MU/IN/GE", "Verbergen", true },
    {14, "A", 1, "KL/KO/KK", "Zechen", false },
    # Gesellschaft
    {15, "B", 2, "MU/KL/CH", "Bekehren / Überzeugen", false },
    {16, "B", 2, "MU/CH/CH", "Betören", nil },
    {17, "B", 2, "MU/IN/CH", "Einschüchtern", false },
    {18, "B", 2, "KL/IN/CH", "Etikette", nil },
    {19, "C", 2, "KL/IN/CH", "Gassenwissen", nil },
    {20, "C", 2, "KL/IN/CH", "Menschenkenntnis", false },
    {21, "C", 2, "MU/IN/CH", "Überreden", false },
    {22, "B", 2, "IN/CH/GE", "Verkleiden", nil },
    {23, "D", 2, "MU/IN/CH", "Willenskraft", false },
    # Talents: Nature
    {24, "C", 3, "MU/IN/CH", "Fährtensuchen", true },
    {25, "A", 3, "KL/FF/KK", "Fesseln", nil },
    {26, "A", 3, "FF/GE/KO", "Fischen & Angeln", nil },
    {27, "B", 3, "KL/IN/IN", "Orientierung", false },
    {28, "C", 3, "KL/FF/KO", "Pflanzenkunde", nil },
    {29, "C", 3, "MU/MU/CH", "Tierkunde", true },
    {30, "C", 3, "MU/GE/KO", "Wildnisleben", true },
    # Talents: Knowledge
    {31, "A", 4, "KL/KL/IN", "Brett- & Glücksspiel", false },
    {32, "B", 4, "KL/KL/IN", "Geographie", false },
    {33, "B", 4, "KL/KL/IN", "Geschichtswissen", false },
    {34, "B", 4, "KL/KL/IN", "Götter & Kulte", false },
    {35, "B", 4, "MU/KL/IN", "Kriegskunst", false },
    {36, "C", 4, "KL/KL/IN", "Magiekunde", false },
    {37, "B", 4, "KL/KL/FF", "Mechanik", false },
    {38, "A", 4, "KL/KL/IN", "Rechnen", false },
    {39, "A", 4, "KL/KL/IN", "Rechtskunde", false },
    {40, "B", 4, "KL/KL/IN", "Sagen & Legenden", false },
    {41, "B", 4, "KL/KL/IN", "Sphärenkunde", false },
    {42, "A", 4, "KL/KL/IN", "Sternkunde", false },
    # Talents: Crafting
    {43, "C", 5, "MU/KL/FF", "Alchimie", true },
    {44, "B", 5, "FF/GE/KK", "Boote & Schiffe", true },
    {45, "A", 5, "CH/FF/KO", "Fahrzeuge", true },
    {46, "B", 5, "KL/IN/CH", "Handel", false },
    {47, "B", 5, "MU/KL/IN", "Heilkunde Gift", true },
    {48, "B", 5, "MU/IN/KO", "Heilkunde Krankheiten", true },
    {49, "B", 5, "IN/CH/KO", "Heilkunde Seele", false },
    {50, "D", 5, "KL/FF/FF", "Heilkunde Wunden", true },
    {51, "B", 5, "FF/GE/KK", "Holzbearbeitung", true },
    {52, "A", 5, "IN/FF/FF", "Lebensmittelbearbeitung", true },
    {53, "B", 5, "FF/GE/KO", "Lederbearbeitung", true },
    {54, "A", 5, "IN/FF/FF", "Malen & Zeichnen", true },
    {55, "C", 5, "FF/KO/KK", "Metallbearbeitung", true },
    {56, "A", 5, "CH/FF/KO", "Musizieren", true },
    {57, "C", 5, "IN/FF/FF", "Schlösserknacken", true },
    {58, "A", 5, "FF/FF/KK", "Steinbearbeitung", true }
  ]

  @species [
    # {id, name, le, sk, zk, gs, ap}
    {1, "Mensch",  5, -5, -5, 8, 0},
    {2, "Elf",     2, -4, -6, 8, 18},
    {3, "Halbelf", 5, -4, -6, 8, 0},
    {4, "Zwerg",   8, -4, -4, 6, 61}
  ]

  @traditions [
    #  {id, magic, le, name, ap}
    {1, nil, nil, "Allgemein", nil},
    # Zauberertraditionen
    {2, true, "KL", "Gildenmagier", 155},
    {3, true, "IN", "Elfen", 125},
    {4, true, "CH", "Hexen", 135},
    # Geweihtentraditionen
    {5, false, "MU", "Boronkirche", 130},
    {6, false, "KL", "Hesindekirche", 130},
    {7, false, "IN", "Perainekirche", 110},
    {8, false, "IN", "Phexkirche", 150},
    {9, false, "KL", "Praioskirche", 130},
    {10, false, "MU", "Rondrakirche", 150}
  ]

  @traits [
    # {id, level, name, ap, details, fixed_ap}
    # Vorteile
    {1, 3, "Adel", 5, true, true},
    {2, 1, "Altersresistenz", 5, false, true},
    {3, 1, "Angenehmer Geruch", 6, false, true},
    {4, 1, "Begabung", 6, true, false},
    {5, 1, "Beidhändig", 15, false, true},
    {6, 2, "Dunkelsicht", 10, false, true},
    {7, 1, "Eisenaffine Aura", 15, false, true},
    {8, 1, "Entfernungssinn", 10, false, true},
    {9, 1, "Flink", 8, false, true},
    {10, 1, "Fuchssinn", 15, false, true},
    {11, 1, "Geborener Redner", 4, false, true},
    {12, 1, "Geweihter", 25, false, true},
    {13, 2, "Giftresistenz", 10, false, true},
    {14, 3, "Glück", 30, false, true},
    {15, 2, "Gutaussehend", 20, false, true},
    {16, 1, "Herausragende Fertigkeit", 2, true, false},
    {17, 1, "Herausragende Kampftechnik", 8, true, false},
    {18, 1, "Herausragender Sinn", 2, true, false},
    {19, 1, "Hitzeresistenz", 5, false, true},
    {20, 7, "Hohe Astralkraft", 6, false, true},
    {21, 7, "Hohe Karmalkraft", 6, false, true},
    {22, 7, "Hohe Lebenskraft", 6, false, true},
    {23, 1, "Hohe Seelenkraft", 25, false, true},
    {24, 1, "Hohe Zähigkeit", 25, false, true},
    {25, 1, "Immunität gegen (Gift)", 25, true, false},
    {26, 1, "Immunität gegen (Krankheit)", 25, true, false},
    {27, 1, "Kälteresistenz", 5, false, true},
    {28, 2, "Krankheitsresistenz", 10, false, true},
    {29, 1, "Magische Einstimmung", 40, true, false},
    {30, 1, "Mystiker", 20, false, true},
    {31, 1, "Nichtschläfer", 8, false, true},
    {32, 1, "Pragmatiker", 10, false, true},
    {33, 10, "Reich", 1, false, true},
    {34, 1, "Richtungssinn", 10, false, true},
    {35, 1, "Schlangenmensch", 6, false, true},
    {36, 1, "Schwer zu verzaubern", 15, false, true},
    {37, 1, "Soziale Anpassungsfähigkeit", 10, false, true},
    {38, 1, "Unscheinbar", 4, false, true},
    {39, 3, "Verbesserte Regeneration (Astralenergie)", 10, false, true},
    {40, 3, "Verbesserte Regeneration (Karmaenergie)", 10, false, true},
    {41, 3, "Verbesserte Regeneration (Lebensenergie)", 10, false, true},
    {42, 1, "Verhüllte Aura", 20, false, true},
    {43, 1, "Vertrauenerweckend", 25, false, true},
    {44, 1, "Waffenbegabung", 5, true, false},
    {45, 1, "Wohlklang", 5, false, true},
    {46, 1, "Zäher Hund", 20, false, true},
    {47, 1, "Zauberer", 25, false, true},
    {48, 1, "Zeitgefühl", 2, false, true},
    {49, 1, "Zweistimmiger Gesang", 5, false, true},
    {50, 1, "Zwergennase", 8, false, true},
    # Nachteile
    {51, 3, "Angst vor", -8, true, true},
    {52, 3, "Arm", -1, false, true},
    {53, 1, "Artefaktgebunden", -10, false, true},
    {54, 1, "Behäbig", -4, false, true},
    {55, 1, "Blind", -50, false, true},
    {56, 1, "Blutrausch", -10, false, true},
    {57, 1, "Eingeschränkter Sinn", -2, true, false},
    {58, 1, "Farbenblind", -2, false, true},
    {59, 1, "Fettleibig", -25, false, true},
    {60, 2, "Giftanfällig", -5, false, true},
    {61, 2, "Hässlich", -10, false, true},
    {62, 1, "Hitzeempfindlich", -3, false, true},
    {63, 1, "Kälteempfindlich", -3, false, true},
    {64, 1, "Keine Flugsalbe", -25, false, true},
    {65, 1, "Kein Vertrauter", -25, false, true},
    {66, 1, "Körpergebundene Kraft", -5, false, true},
    {67, 1, "Körperliche Auffälligkeit", -2, true, true},
    {68, 2, "Krankheitsanfällig", -5, false, true},
    {69, 1, "Lästige Mindergeister", -20, false, true},
    {70, 1, "Lichtempfindlich", -20, false, true},
    {80, 1, "Magische Einschränkung", -30, true, true},
    {81, 1, "Nachtblind", -10, false, true},
    {82, 7, "Niedrige Astralkraft", -2, false, true},
    {83, 7, "Niedrige Karmalkraft", -2, false, true},
    {84, 7, "Niedrige Lebenskraft", -2, false, true},
    {85, 1, "Niedrige Seelenkraft", -25, false, true},
    {86, 1, "Niedrige Zähigkeit", -25, false, true},
    {87, 3, "Pech", -20, false, true},
    {88, 1, "Pechmagnet", -5, false, true},
    {89, 1, "Persönlichkeitsschwächen", -5, true, false},
    {90, 3, "Prinzipientreue", -10, true, true},
    {91, 1, "Schlafwandler", -10, false, true},
    {92, 1, "Schlechte Angewohnheit", -2, true, true},
    {93, 1, "Schlechte Eigenschaft", -5, true, false},
    {94, 3, "Schlechte Regeneration (Astralenergie)", -10, false, true},
    {95, 3, "Schlechte Regeneration (Karmaenergie)", -10, false, true},
    {96, 3, "Schlechte Regeneration (Lebensenergie)", -10, false, true},
    {97, 1, "Schwacher Astralkörper", -15, false, true},
    {98, 1, "Schwacher Karmalkörper", -15, false, true},
    {99, 1, "Sensibler Geruchssinn", -10, false, true},
    {100, 1, "Sprachfehler", -15, false, true},
    {101, 1, "Stigma", -10, true, true},
    {101, 1, "Stumm", -40, false, true},
    {102, 1, "Taub", -40, false, true},
    {103, 1, "Unfähig", -1, true, false},
    {104, 1, "Unfrei", -8, false, true},
    {105, 1, "Verpflichtungen", -10, true, true},
    {106, 1, "Verstümmelt", -5, true, false},
    {107, 1, "Wahrer Name", -10, false, true},
    {108, 1, "Wilde Magie", -10, false, true},
    {109, 2, "Zauberanfällig", -12, false, true},
    {110, 1, "Zerbrechlich", -20, false, true},
    # Allgemeine Sonderfertigkeiten (Basisregelwerk)
    {111, 0, "Analytiker", 5, false, true},
    {112, 0, "Anführer", 10, false, true},
    {113, 0, "Berufsgeheimnis", 1, true, false},
    {114, 0, "Dokumentfälscher", 5, false, true},
    {115, 0, "Eiserner Wille I", 15, false, true},
    {116, 0, "Eiserner Wille II", 15, false, true},
    {117, 0, "Fächersprache", 3, false, true},
    {118, 0, "Fallen entschärfen", 5, false, true},
    {119, 0, "Falschspielen", 5, false, true},
    {120, 0, "Fertigkeitsspezialisierung (Talente)", 1, true, false},
    {121, 0, "Fischer", 3, false, true},
    {122, 0, "Füchsisch", 3, false, true},
    {123, 0, "Geländekunde", 15, false, true},
    {124, 0, "Gildenrecht", 2, false, true},
    {125, 0, "Glasbläserei", 2, false, true},
    {126, 0, "Hehlerei", 5, false, true},
    {127, 0, "Heraldik", 2, false, true},
    {128, 0, "Instrumente bauen", 2, false, true},
    {129, 0, "Jäger", 5, false, true},
    {130, 0, "Kartographie", 5, false, true},
    {131, 0, "Lippenlesen", 10, false, true},
    {132, 0, "Meister der Improvisation", 10, false, true},
    {133, 0, "Ortskenntnis", 2, true, false},
    {134, 0, "Rosstäuscher", 5, false, true},
    {135, 0, "Sammler", 2, false, true},
    {136, 0, "Schmerzen unterdrücken", 20, false, true},
    {137, 0, "Schnapsbrennerei", 2, false, true},
    {138, 0, "Schrift", 2, true, false},
    {139, 0, "Schriftstellerei", 2, true, true},
    {140, 0, "Sprache I", 2, true, true},
    {141, 0, "Sprache II", 2, true, true},
    {142, 0, "Sprache III", 6, true, true},
    {143, 0, "Tierstimmen imitieren", 5, false, true},
    {144, 0, "Töpferei", 2, false, true},
    {145, 0, "Wettervorhersage", 2, false, true},
    {146, 0, "Zahlenmystik", 2, false, true},
    # Schicksalspunkte Sonderfertigkeiten
    {147, -1, "Attacke verbessern", 5, false, true},
    {148, -1, "Ausweichen verbessern", 5, false, true},
    {149, -1, "Eigenschaft verbessern", 5, false, true},
    {150, -1, "Fernkampf verbessern", 5, false, true},
    {151, -1, "Parade verbessern", 5, false, true},
    {152, -1, "Wachsamkeit verbessern", 10, false, true},
    # Kampfsonderfertigkeiten
    {153, -3, "Aufmerksamkeit", 10, false, true}, # @all_combat_skills},
    {154, -3, "Belastungsgewöhnung I", 20, false, true}, # @all_combat_skills},
    {155, -3, "Belastungsgewöhnung II", 35, false, true}, # @all_combat_skills},
    {156, -3, "Beidhändiger Kampf I", 20, false, true}, # [1,3,4,8,9,10]},
    {157, -3, "Beidhändiger Kampf II", 35, false, true}, # [1,3,4,8,9,10]},
    {158, -3, "Berittener Kampf", 20, false, true}, # @all_combat_skills},
    {159, -3, "Berittener Schütze", 10, false, true}, # [15, 17, 21]},
    {160, -3, "Einhändiger Kampf", 10, false, true}, # [3, 10]},
    {161, -3, "Entwaffnen", 40, false, true}, # [3, 4, 7, 8, 10, 11, 12, 13, 14]},
    {162, -3, "Feindgespür", 10, false, true}, # @all_combat_skills},
    {163, -3, "Finte I", 15, false, true}, # [1, 3, 4, 7, 8, 10, 12, 13, 14]},
    {164, -3, "Finte II", 20, false, true}, # [1, 3, 4, 7, 8, 10, 12, 13, 14]},
    {165, -3, "Finte III", 25, false, true}, # [1, 3, 4, 7, 8, 10, 12, 13, 14]},
    {166, -3, "Haltegriff", 5, false, true}, # [8]},
    {167, -3, "Hammerschlag", 25, false, true}, # [4, 5, 10, 13, 14]},
    {168, -3, "Kampfreflexe I", 10, false, true}, # @all_combat_skills}, // done
    {169, -3, "Kampfreflexe II", 15, false, true}, # @all_combat_skills}, // done
    {170, -3, "Kampfreflexe III", 20, false, true}, # @all_combat_skills}, // done
    {171, -3, "Klingenfänger", 10, false, true}, # [1]},
    {172, -3, "Kreuzblock", 10, false, true}, # [1, 3]},
    {173, -3, "Lanzenangriff", 10, false, true}, # [6]},
    {174, -3, "Präziser Schuss/Wurf I", 15, false, true}, # [15, 16, 17, 18, 20, 21]},
    {175, -3, "Präziser Schuss/Wurf II", 20, false, true}, # [15, 16, 17, 18, 20, 21]},
    {176, -3, "Präziser Schuss/Wurf III", 25, false, true}, # [15, 16, 17, 18, 20, 21]},
    {177, -3, "Präziser Stich I", 15, false, true}, # [1, 3]},
    {178, -3, "Präziser Stich II", 20, false, true}, # [1, 3]},
    {179, -3, "Präziser Stich III", 25, false, true}, # [1, 3]},
    {180, -3, "Riposte", 40, false, true}, # [1, 3]},
    {181, -3, "Rundumschlag I", 25, false, true}, # [4, 5, 9, 10, 12, 13, 14]},
    {182, -3, "Rundumschlag II", 35, false, true}, # [4, 5, 9, 10, 12, 13, 14]},
    {183, -3, "Schildspalter", 15, false, true}, # [4, 5, 13, 14]},
    {184, -3, "Schnellladen (Armbrüste)", 5, false, true}, # [15]},
    {185, -3, "Schnellladen (Bögen)", 20, false, true}, # [17]},
    {186, -3, "Schnellladen (Wurfwaffen)", 10, false, true}, # [21]},
    {187, -3, "Schnellziehen", 10, false, true}, # [1, 3, 4, 5, 7, 10, 12, 13, 14]},
    {188, -3, "Sturmangriff", 25, false, true}, # [4, 10, 12, 13, 14]},
    {189, -3, "Todesstoß", 30, false, true}, # [1, 3]},
    {190, -3, "Verbessertes Ausweichen I", 15, false, true}, # @all_combat_skills},        // done
    {191, -3, "Verbessertes Ausweichen II", 20, false, true}, # @all_combat_skills},       // done
    {192, -3, "Verbessertes Ausweichen III", 25, false, true}, # @all_combat_skills},      // done
    {193, -3, "Verteidigungshaltung", 10, false, true}, # [1, 3, 4, 8, 9, 10, 12, 13, 14]},
    {194, -3, "Vorstoß", 10, false, true}, # [1, 3, 4, 5, 8, 10, 12, 13, 14]},
    {195, -3, "Wuchtschlag I", 15, false, true}, # [4, 5, 8, 10, 12, 13, 14]},
    {196, -3, "Wuchtschlag II", 20, false, true}, # [4, 5, 8, 10, 12, 13, 14]},
    {197, -3, "Wuchtschlag III", 25, false, true}, # [4, 5, 8, 10, 12, 13, 14]},
    {198, -3, "Wurf", 10, false, true}, # [8]},
    {199, -3, "Zu Fall bringen", 20, false, true}, # [7, 12]},
    # Ruestkammer erweiterung
    {200, -3, "Schnellladen (Blasrohre)", 5, false, true}, # [16]},
    {201, -3, "Schnellladen (Diskusse)", 5, false, true}, # [18]},
    {202, -3, "Schnellladen (Schleudern)", 5, false, true}, # [20]},
    {203, -3, "Ballistischer Schuss", 10, false, true}, # [17]},
    {204, -3, "Betäubungsschlag", 15, false, true}, # [4, 10, 12]},
    {205, -3, "Festnageln", 20, false, true}, # [12]},
    {206, -3, "Klingensturm", 25, false, true}, # [1, 3, 4, 10]},
    {207, -3, "Unterlaufen I", 10, false, true}, # [1, 3, 4, 5, 8, 9, 10, 13, 14]},
    {208, -3, "Unterlaufen II", 15, false, true}, # [1, 3, 4, 5, 8, 9, 10, 13, 14]},
    {209, -3, "Binden", 25, false, true}, # [1, 3, 10, 12]},
    {210, -3, "Hohe Klinge", 15, false, true}, # [3, 10, 14]},
    {211, -3, "Sprungangriff", 20, false, true}, # [3, 10, 14]},
    {212, -3, "Vorbeiziehen", 15, false, true}, # [1, 3, 4, 10]},
    {213, -3, "Weiter Schwung", 15, false, true}, # [13, 14]},
    {214, -3, "Windmühle", 25, false, true}, # [4, 10, 13, 13, 14]},
    {215, -3, "Wuchtiger Wurf", 15, false, true}, # [21]},
    {216, -3, "Zertrümmern", 5, false, true}, # [4, 5, 13]},
    {217, -3, "Drohgebärden", 10, false, true}, # @all_combat_skills},
    # Magische Sonderfertigkeiten
    {218, -4, "Aura verbergen", 20, false, true},
    {219, -4, "Merkmalskenntnis", 10, true, false},
    {220, -4, "Starke Zaubertricks", 2, false, true},
    {221, -4, "Verbotene Pforten", 10, false, true},
    {222, -4, "Zauberzeichen", 20, false, true},
    # Zaubertricks
    {223, -6, "Abkühlung", 1, false, true},
    {224, -6, "Bauchreden", 1, false, true},
    {225, -6, "Duft", 1, false, true},
    {226, -6, "Feuerfinger", 1, false, true},
    {227, -6, "Glücksgriff", 1, false, true},
    {228, -6, "Handwärmer", 1, false, true},
    {229, -6, "Lockruf", 1, false, true},
    {230, -6, "Regenbogenaugen", 1, false, true},
    {231, -6, "Schlangenhände", 1, false, true},
    {232, -6, "Schnipsen", 1, false, true},
    {233, -6, "Signatur", 1, false, true},
    {234, -6, "Trocken", 1, false, true},
    # Karmale Sonderfertigkeiten
    {235, -5, "Aspektkenntnis", 15, true, false},
    {236, -5, "Fokussierung", 8, false, true},
    {237, -5, "Stärke des Glaubens", 10, false, true},
    {238, -5, "Starke Segnungen", 2, false, true},
    # Segnungen
    {239, -7, "Eidsegen", 1, false, true},
    {240, -7, "Feuersegen", 1, false, true},
    {241, -7, "Geburtssegen", 1, false, true},
    {242, -7, "Glückssegen", 1, false, true},
    {243, -7, "Grabsegen", 1, false, true},
    {244, -7, "Harmoniesegen", 1, false, true},
    {245, -7, "Kleiner Heilsegen", 1, false, true},
    {246, -7, "Kleiner Schutzsegen", 1, false, true},
    {247, -7, "Speisesegen", 1, false, true},
    {248, -7, "Stärkungssegen", 1, false, true},
    {249, -7, "Tranksegen", 1, false, true},
    {250, -7, "Weisheitssegen", 1, false, true},
    # Stabzauber
    {251, -8, "Bindung des Stabes", 10, false, false},
    {252, -8, "Doppeltes Maß", 5, false, true},
    {253, -8, "Ewige Flamme", 10, false, true},
    {254, -8, "Flammenschwert", 35, false, true},
    {255, -8, "Kraftfokus", 30, false, true},
    {256, -8, "Merkmalsfokus", 35, false, true},
    {257, -8, "Seil des Adepten", 10, false, true},
    {258, -8, "Stab-Apport", 15, false, true},
    # Hexen
    {260, -9, "Vertrautenbindung", 20, false, true},
    {261, -9, "Flugsalbe", 15, false, true}
  ]

  @spells [
    # {id, sf, probe, name, traditions}
    {1, "B", "KL/IN/FF", "Adlerauge", [3]},
    {2, "D", "KL/IN/FF", "Arcanovi", [1]},
    {3, "C", "KL/KL/IN", "Analys Arkanstruktur", [1]},
    {4, "C", "KL/IN/FF", "Armatrutz", [1]},
    {5, "B", "KL/IN/FF", "Axxeleratus", [3]},
    {6, "B", "KL/IN/FF", "Balsam Salabunde", [1]},
    {7, "B", "MU/IN/CH", "Bannbaladin", [1]},
    {8, "C", "MU/KL/IN", "Blick in die Gedanken", [1]},
    {9, "A", "MU/IN/CH", "Blitz dich find", [1]},
    {10, "C", "KL/IN/KO", "Corpofesso", [2]},
    {11, "B", "MU/KL/CH", "Disruptivo", [1]},
    {12, "C", "MU/CH/KO", "Dschinnenruf", [2]},
    {13, "C", "KL/IN/CH", "Duplicatus", [2]},
    {14, "B", "MU/CH/KO", "Elementarer Diener", [2]},
    {15, "B", "MU/KL/IN", "Falkenauge", [3]},
    {16, "A", "MU/KL/CH", "Flim Flam", [1]},
    {17, "C", "KL/IN/KO", "Fulminictus", [3]},
    {18, "B", "MU/KL/CH", "Gardianum", [2]},
    {19, "B", "MU/IN/CH", "Große Gier", [4]},
    {20, "B", "KL/IN/CH", "Harmlose Gestalt", [4]},
    {21, "B", "KL/IN/KO", "Hexengalle", [4]},
    {22, "A", "KL/IN/KO", "Hexenkrallen", [4]},
    {23, "B", "MU/IN/CH", "Horriphobus", [2]},
    {24, "C", "MU/KL/CH", "Ignifaxius", [2]},
    {25, "C", "MU/CH/KO", "Invocatio Maior", [2, 4]},
    {26, "A", "MU/CH/KO", "Invocatio Minima", [2, 4]},
    {27, "B", "MU/CH/KO", "Invocatio Minor", [2, 4]},
    {28, "A", "KL/IN/KO", "Katzenaugen", [4]},
    {29, "A", "KL/IN/KO", "Krötensprung", [4]},
    {30, "A", "MU/KL/CH", "Manifesto", [1]},
    {31, "A", "KL/FF/KK", "Manus Miracula", [1]},
    {32, "B", "KL/FF/KK", "Motoricus", [1]},
    {33, "C", "MU/KL/CH", "Nebelwand", [3]},
    {34, "B", "KL/IN/CH", "Oculus Illusionis", [2]},
    {35, "A", "KL/IN/IN", "Odem Arcanum", [1]},
    {36, "B", "KL/IN/KO", "Paralysis", [2]},
    {37, "B", "MU/KL/IN", "Penetrizzel", [2]},
    {38, "B", "KL/IN/FF", "Psychostabilis", [1]},
    {39, "B", "KL/FF/KK", "Radau", [4]},
    {40, "B", "MU/IN/CH", "Respondami", [2]},
    {41, "C", "KL/IN/KO", "Salander", [2]},
    {42, "A", "MU/IN/CH", "Sanftmut", [4]},
    {43, "B", "KL/IN/KO", "Satuarias Herrlichkeit", [4]},
    {44, "B", "KL/FF/KK", "Silentium", [3]},
    {45, "B", "MU/IN/CH", "Somnigravis", [3]},
    {46, "A", "KL/IN/KO", "Spinnenlauf", [4]},
    {47, "B", "KL/FF/KK", "Spurlos", [3]},
    {48, "C", "MU/CH/KO", "Transversalis", [2]},
    {49, "B", "KL/IN/KO", "Visibili", [3]},
    {50, "B", "KL/IN/KO", "Wasseratem", [3]},
    {51, "D", "KL/IN/FF", "Zauberklinge Geisterspeer", [1]}
  ]

  @prayers [
    # {id, sf, probe, name, traditions}
    {1, "B", "MU/KL/IN", "Ackersegen", [7]},
    {2, "A", "MU/KL/CH", "Bann der Dunkelheit", [9]},
    {3, "B", "IN/CH/CH", "Bann der Furcht", [5]},
    {4, "B", "MU/KL/CH", "Bann des Lichts", [5, 8]},
    {5, "A", "MU/KL/IN", "Blendstrahl", [9]},
    {6, "B", "MU/IN/CH", "Ehrenhaftigkeit", [10]},
    {7, "A", "KL/KL/IN", "Entzifferung", [6]},
    {8, "B", "MU/IN/CH", "Ermutigung", [10]},
    {9, "B", "MU/IN/CH", "Exorzismus", [1, 5, 9]},
    {10, "A", "MU/IN/GE", "Fall ins Nichts", [8]},
    {11, "B", "MU/IN/CH", "Friedvolle Aura", [7, 6]},
    {12, "B", "MU/IN/CH", "Geweihter Panzer", [10]},
    {13, "B", "KL/IN/CH", "Giftbann", [7]},
    {14, "A", "KL/IN/IN", "Göttlicher Fingerzeig", [1]},
    {15, "A", "IN/IN/CH", "Göttliches Zeichen", [1]},
    {16, "B", "KL/IN/CH", "Heilsegen", [7]},
    {17, "B", "MU/MU/CH", "Kleiner Bann wider Untote", [5]},
    {18, "B", "MU/IN/CH", "Kleiner Bannstrahl", [9]},
    {19, "B", "KL/IN/CH", "Krankheitsbann", [7]},
    {20, "B", "IN/IN/GE", "Lautlos", [8]},
    {21, "B", "MU/KL/IN", "Löwengestalt", [10]},
    {22, "C", "MU/IN/CH", "Magieschutz", [6, 9]},
    {23, "A", "KL/IN/IN", "Magiesicht", [6, 9]},
    {24, "A", "KL/KL/IN", "Mondsicht", [8]},
    {25, "B", "KL/IN/CH", "Mondsilberzunge", [8]},
    {26, "B", "KL/IN/CH", "Nebelleib", [8]},
    {27, "B", "MU/IN/CH", "Objektsegen", [1]},
    {28, "C", "KL/IN/CH", "Objektweihe", [1]},
    {29, "A", "MU/KL/IN", "Ort der Ruhe", [5]},
    {30, "A", "KL/IN/CH", "Pflanzenwuchs", [7]},
    {31, "A", "MU/KL/IN", "Rabenruf", [5]},
    {32, "B", "KL/IN/CH", "Schlaf", [5]},
    {33, "B", "MU/KL/IN", "Schlangenstab", [6]},
    {34, "A", "MU/KL/IN", "Schlangenzunge", [6]},
    {35, "C", "MU/IN/KO", "Schmerzresistenz", [10]},
    {36, "B", "MU/IN/CH", "Schutz der Wehrlosen", [10]},
    {37, "A", "KL/IN/CH", "Sternenglanz", [8]},
    {38, "C", "MU/KL/IN", "Wahrheit", [9]},
    {39, "B", "IN/IN/GE", "Wieselflink", [8]},
    {40, "B", "KL/KL/IN", "Wundersame Verständigung", [6, 8]}
  ]

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: @name)

  def init(_) do
    :ets.new(:armors, [:ordered_set, :protected, :named_table])
    :ets.insert(:armors, @armors)

    :ets.new(:combat_skills, [:ordered_set, :protected, :named_table])
    :ets.insert(:combat_skills, @combat_skills)

    :ets.new(:fweapons, [:ordered_set, :protected, :named_table])
    :ets.insert(:fweapons, @fweapons)

    :ets.new(:mweapons, [:ordered_set, :protected, :named_table])
    :ets.insert(:mweapons, @mweapons)

    :ets.new(:skills, [:ordered_set, :protected, :named_table])
    :ets.insert(:skills, @skills)

    :ets.new(:prayers, [:ordered_set, :protected, :named_table])
    :ets.insert(:prayers, @prayers)

    :ets.new(:species, [:ordered_set, :protected, :named_table])
    :ets.insert(:species, @species)

    :ets.new(:spells, [:ordered_set, :protected, :named_table])
    :ets.insert(:spells, @spells)

    :ets.new(:traditions, [:ordered_set, :protected, :named_table])
    :ets.insert(:traditions, @traditions)

    :ets.new(:traits, [:ordered_set, :protected, :named_table])
    :ets.insert(:traits, @traits)

    {:ok, "In-Memory Database created and filled."}
  end

  # Armors
  def armors, do: :ets.tab2list(:armors)

  def armor(id, :name), do: :ets.lookup_element(:armors, id, 2)

  # combat skills
  def combat_skills, do: :ets.tab2list(:combat_skills)

  def combat_skill(id, :ge), do: :ets.lookup_element(:combat_skills, id, 5)
  def combat_skill(id, :kk), do: :ets.lookup_element(:combat_skills, id, 6)
  def combat_skill(id, :name), do: :ets.lookup_element(:combat_skills, id, 7)
  def combat_skill(id, :parade), do: :ets.lookup_element(:combat_skills, id, 4)
  def combat_skill(id, :ranged), do: :ets.lookup_element(:combat_skills, id, 3)
  def combat_skill(id, :sf), do: :ets.lookup_element(:combat_skills, id, 2)

  # fweapons
  def fweapons, do: :ets.tab2list(:fweapons)

  # mweapons
  def mweapons, do: :ets.tab2list(:mweapons)

  # skills
  def skills, do: :ets.tab2list(:skills)

  def skill(id, :category), do: :ets.lookup_element(:skills, id, 3)
  def skill(id, :name), do: :ets.lookup_element(:skills, id, 5)
  def skill(id, :probe), do: :ets.lookup_element(:skills, id, 4)
  def skill(id, :sf), do: :ets.lookup_element(:skills, id, 2)
  def skill(id, :be), do: :ets.lookup_element(:skills, id, 6)

  # Prayers
  def prayers, do: :ets.tab2list(:prayers)

  def prayer_options() do
    Enum.map(prayers(), fn {id, _sf, _probe, name, _traditions} -> {name, id} end)
  end

  def prayer(id, :name), do: :ets.lookup_element(:prayers, id, 4)
  def prayer(id, :probe), do: :ets.lookup_element(:prayers, id, 3)
  def prayer(id, :sf), do: :ets.lookup_element(:prayers, id, 2)

  def valid_prayer?(id), do: :ets.member(:prayers, id)

  # Spells
  def spells, do: :ets.tab2list(:spells)

  def spell_options() do
    Enum.map(spells(), fn {id, _sf, _probe, name, _traditions} -> {name, id} end)
  end

  def spell(id, :name), do: :ets.lookup_element(:spells, id, 4)
  def spell(id, :probe), do: :ets.lookup_element(:spells, id, 3)
  def spell(id, :sf), do: :ets.lookup_element(:spells, id, 2)

  def valid_spell?(id), do: :ets.member(:spells, id)

  # Species
  def species, do: :ets.tab2list(:species)

  def species_options do
    Enum.map(species(), fn {id, name, _le, _sk, _zk, _gs, _ap} -> {name, id} end)
  end

  def species(id, :name), do: :ets.lookup_element(:species, id, 2)
  def species(id, :le), do: :ets.lookup_element(:species, id, 3)
  def species(id, :sk), do: :ets.lookup_element(:species, id, 4)
  def species(id, :zk), do: :ets.lookup_element(:species, id, 5)
  def species(id, :ge), do: :ets.lookup_element(:species, id, 6)
  def species(id, :ap), do: :ets.lookup_element(:species, id, 7)

  # Traditions

  def traditions, do: :ets.tab2list(:traditions)

  def tradition(id) do
    case :ets.lookup(:traditions, id) do
      [] -> nil
      [data] -> data
    end
  end

  def tradition(nil, _), do: nil
  def tradition(id, :ap), do: :ets.lookup_element(:traditions, id, 5)
  def tradition(id, :le), do: :ets.lookup_element(:traditions, id, 3)
  def tradition(id, :name), do: :ets.lookup_element(:traditions, id, 4)

  def tradition_options(:magic) do
    traditions()
    |> Enum.filter(fn {_id, magic, _le, _name, _ap} -> magic end)
    |> Enum.map(fn {id, _magic, _le, name, _ap} -> {name, id} end)
  end

  def tradition_options(:karmal) do
    traditions()
    |> Enum.filter(fn {_id, magic, _le, _name, _ap} -> magic == false end)
    |> Enum.map(fn {id, _magic, _le, name, _ap} -> {name, id} end)
  end

  # traits
  def traits, do: :ets.tab2list(:traits)

  def trait(id) do
    case :ets.lookup(:traits, id) do
      [] -> nil
      [data] -> data
    end
  end

  def trait_options do
    Enum.map(traits(), fn {id, _level, name, _ap, _details, _fixed_ap} -> {name, id} end)
  end
end
