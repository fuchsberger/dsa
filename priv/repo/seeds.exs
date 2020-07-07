# Script for populating the database. You can run it as:
# mix run priv/repo/seeds.exs

alias Dsa.{Accounts, Game}

# CREATE TALENTS

# Talents: Body
Game.create_skill!("Körper", "MU/IN/GE", "Fliegen", true)
Game.create_skill!("Körper", "MU/CH/FF", "Gaukeleien", true)
Game.create_skill!("Körper", "MU/GE/KK", "Klettern", true)
Game.create_skill!("Körper", "GE/GE/KO", "Körperbeherrschung", true)
Game.create_skill!("Körper", "KO/KK/KK", "Kraftakt", true)
Game.create_skill!("Körper", "CH/GE/KK", "Reiten", true)
Game.create_skill!("Körper", "GE/KO/KK", "Schwimmen", true)
Game.create_skill!("Körper", "MU/MU/KO", "Selbstbeherrschung", false)
Game.create_skill!("Körper", "KL/CH/KO", "Singen")
Game.create_skill!("Körper", "KL/IN/IN", "Sinnesschärfe")
Game.create_skill!("Körper", "KL/CH/GE", "Tanzen", true)
Game.create_skill!("Körper", "MU/FF/GE", "Taschendiebstahl", true)
Game.create_skill!("Körper", "MU/IN/GE", "Verbergen", true)
Game.create_skill!("Körper", "KL/KO/KK", "Zechen", false)

# Talents: Social
Game.create_skill!("Gesellschaft", "MU/KL/CH", "Bekehren / Überzeugen", false)
Game.create_skill!("Gesellschaft", "MU/CH/CH", "Betören")
Game.create_skill!("Gesellschaft", "MU/IN/CH", "Einschüchtern", false)
Game.create_skill!("Gesellschaft", "KL/IN/CH", "Etikette")
Game.create_skill!("Gesellschaft", "KL/IN/CH", "Gassenwissen")
Game.create_skill!("Gesellschaft", "KL/IN/CH", "Menschenkenntnis", false)
Game.create_skill!("Gesellschaft", "MU/IN/CH", "Überreden", false)
Game.create_skill!("Gesellschaft", "IN/CH/GE", "Verkleiden")
Game.create_skill!("Gesellschaft", "MU/IN/CH", "Willenskraft", false)

# Talents: Nature
Game.create_skill!("Natur", "MU/IN/CH", "Fährtensuchen", true)
Game.create_skill!("Natur", "KL/FF/KK", "Fesseln")
Game.create_skill!("Natur", "FF/GE/KO", "Fischen & Angeln")
Game.create_skill!("Natur", "KL/IN/IN", "Orientierung", false)
Game.create_skill!("Natur", "KL/FF/KO", "Pflanzenkunde")
Game.create_skill!("Natur", "MU/MU/CH", "Tierkunde", true)
Game.create_skill!("Natur", "MU/GE/KO", "Wildnisleben", true)

# Talents: Knowledge
Game.create_skill!("Wissen", "KL/KL/IN", "Brett- & Glücksspiel", false)
Game.create_skill!("Wissen", "KL/KL/IN", "Geographie", false)
Game.create_skill!("Wissen", "KL/KL/IN", "Geschichtswissen", false)
Game.create_skill!("Wissen", "KL/KL/IN", "Götter & Kulte", false)
Game.create_skill!("Wissen", "MU/KL/IN", "Kriegskunst", false)
Game.create_skill!("Wissen", "KL/KL/IN", "Magiekunde", false)
Game.create_skill!("Wissen", "KL/KL/FF", "Mechanik", false)
Game.create_skill!("Wissen", "KL/KL/IN", "Rechnen", false)
Game.create_skill!("Wissen", "KL/KL/IN", "Rechtskunde", false)
Game.create_skill!("Wissen", "KL/KL/IN", "Sagen & Legenden", false)
Game.create_skill!("Wissen", "KL/KL/IN", "Sphärenkunde", false)
Game.create_skill!("Wissen", "KL/KL/IN", "Sternkunde", false)

# Talents: Crafting
Game.create_skill!("Handwerk", "MU/KL/FF", "Alchimie", true)
Game.create_skill!("Handwerk", "FF/GE/KK", "Boote & Schiffe", true)
Game.create_skill!("Handwerk", "CH/FF/KO", "Fahrzeuge", true)
Game.create_skill!("Handwerk", "KL/IN/CH", "Handel", false)
Game.create_skill!("Handwerk", "MU/KL/IN", "Heilkunde Gift", true)
Game.create_skill!("Handwerk", "MU/IN/KO", "Heilkunde Krankheiten", true)
Game.create_skill!("Handwerk", "IN/CH/KO", "Heilkunde Seele", false)
Game.create_skill!("Handwerk", "KL/FF/FF", "Heilkunde Wunden", true)
Game.create_skill!("Handwerk", "FF/GE/KK", "Holzbearbeitung", true)
Game.create_skill!("Handwerk", "IN/FF/FF", "Lebensmittelbearbeitung", true)
Game.create_skill!("Handwerk", "FF/GE/KO", "Lederbearbeitung", true)
Game.create_skill!("Handwerk", "IN/FF/FF", "Malen & Zeichnen", true)
Game.create_skill!("Handwerk", "FF/KO/KK", "Metallbearbeitung", true)
Game.create_skill!("Handwerk", "CH/FF/KO", "Musizieren", true)
Game.create_skill!("Handwerk", "IN/FF/FF", "Schlösserknacken", true)
Game.create_skill!("Handwerk", "FF/FF/KK", "Steinbearbeitung", true)
Game.create_skill!("Handwerk", "KL/FF/FF", "Stoffbearbeitung", true)

# Create Admin User
{:ok, alex} = Accounts.register_user(%{
  name: "Alex Fuchsberger",
  username: "admin",
  password: "p#7NDQ2y@0^f#WS3$j3u5@jPUjWcRlws"
})

Accounts.set_role(alex, :admin, true)
Game.create_group(%{name: "DSA", master: alex.id})

Game.create_character(alex, %{
  name: "Test",
  species: "Mensch",
  culture: "Mittelreich",
  profession: "Rondrageweihter"
})
