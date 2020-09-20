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
    Dsa.Data.Advantage.seed()
    Dsa.Data.Blessing.seed()
    Dsa.Data.Disadvantage.seed()
    Dsa.Data.CombatSkill.seed()
    Dsa.Data.CombatTrait.seed()
    Dsa.Data.FateTrait.seed()
    Dsa.Data.GeneralTrait.seed()
    Dsa.Data.KarmalTradition.seed()
    Dsa.Data.KarmalTrait.seed()
    Dsa.Data.Language.seed()
    Dsa.Data.MagicTradition.seed()
    Dsa.Data.MagicTrait.seed()
    Dsa.Data.Script.seed()
    Dsa.Data.SpellTrick.seed()
    Dsa.Data.StaffSpell.seed()

    :ets.new(:armors, [:ordered_set, :protected, :named_table])
    :ets.insert(:armors, @armors)

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

    {:ok, "In-Memory Database created and filled."}
  end

  # Armors
  def armors, do: :ets.tab2list(:armors)

  def armor(id, :name), do: :ets.lookup_element(:armors, id, 2)

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
end
