# Script for populating the database. You can run it as:
# mix run priv/repo/seeds.exs

defmodule Dsa.Seed do
  alias Dsa.Lore.{CombatSkill, Skill}

  def combat_skill({sf, ranged, parade, e1, name, e2}) do
    %CombatSkill{}
    |> CombatSkill.changeset(%{
        name: name,
        ranged: ranged,
        parade: parade,
        e1: e1,
        e2: e2,
        sf: sf
      })
    |> Dsa.Repo.insert!()
  end

  def skill({sf, category, probe, name, be}) do
    [e1, e2, e3] =
      case String.split(probe, "/") do
        [e1] -> [e1, nil, nil]
        [e1, e2] -> [e1, e2, nil]
        [e1, e2, e3] -> [e1, e2, e3]
      end

    %Skill{}
    |> Skill.changeset(%{
        name: name,
        category: category,
        e1: e1,
        e2: e2,
        e3: e3,
        be: be,
        sf: sf
      })
    |> Dsa.Repo.insert!()
  end
end

[
  # Körper
  { "B", "Körper", "MU/IN/GE", "Fliegen", true },
  { "A", "Körper", "MU/CH/FF", "Gaukeleien", true },
  { "B", "Körper", "MU/GE/KK", "Klettern", true },
  { "D", "Körper", "GE/GE/KO", "Körperbeherrschung", true },
  { "B", "Körper", "KO/KK/KK", "Kraftakt", true },
  { "B", "Körper", "CH/GE/KK", "Reiten", true },
  { "B", "Körper", "GE/KO/KK", "Schwimmen", true },
  { "D", "Körper", "MU/MU/KO", "Selbstbeherrschung", false },
  { "A", "Körper", "KL/CH/KO", "Singen", nil },
  { "D", "Körper", "KL/IN/IN", "Sinnesschärfe", nil },
  { "A", "Körper", "KL/CH/GE", "Tanzen", true },
  { "B", "Körper", "MU/FF/GE", "Taschendiebstahl", true },
  { "C", "Körper", "MU/IN/GE", "Verbergen", true },
  { "A", "Körper", "KL/KO/KK", "Zechen", false },

  # Gesellschaft
  { "B", "Gesellschaft", "MU/KL/CH", "Bekehren / Überzeugen", false },
  { "B", "Gesellschaft", "MU/CH/CH", "Betören", nil },
  { "B", "Gesellschaft", "MU/IN/CH", "Einschüchtern", false },
  { "B", "Gesellschaft", "KL/IN/CH", "Etikette", nil },
  { "C", "Gesellschaft", "KL/IN/CH", "Gassenwissen", nil },
  { "C", "Gesellschaft", "KL/IN/CH", "Menschenkenntnis", false },
  { "C", "Gesellschaft", "MU/IN/CH", "Überreden", false },
  { "B", "Gesellschaft", "IN/CH/GE", "Verkleiden", nil },
  { "D", "Gesellschaft", "MU/IN/CH", "Willenskraft", false },

  # Talents: Nature
  { "C", "Natur", "MU/IN/CH", "Fährtensuchen", true },
  { "A", "Natur", "KL/FF/KK", "Fesseln", nil },
  { "A", "Natur", "FF/GE/KO", "Fischen & Angeln", nil },
  { "B", "Natur", "KL/IN/IN", "Orientierung", false },
  { "C", "Natur", "KL/FF/KO", "Pflanzenkunde", nil },
  { "C", "Natur", "MU/MU/CH", "Tierkunde", true },
  { "C", "Natur", "MU/GE/KO", "Wildnisleben", true },

  # Talents: Knowledge
  { "A", "Wissen", "KL/KL/IN", "Brett- & Glücksspiel", false },
  { "B", "Wissen", "KL/KL/IN", "Geographie", false },
  { "B", "Wissen", "KL/KL/IN", "Geschichtswissen", false },
  { "B", "Wissen", "KL/KL/IN", "Götter & Kulte", false },
  { "B", "Wissen", "MU/KL/IN", "Kriegskunst", false },
  { "C", "Wissen", "KL/KL/IN", "Magiekunde", false },
  { "B", "Wissen", "KL/KL/FF", "Mechanik", false },
  { "A", "Wissen", "KL/KL/IN", "Rechnen", false },
  { "A", "Wissen", "KL/KL/IN", "Rechtskunde", false },
  { "B", "Wissen", "KL/KL/IN", "Sagen & Legenden", false },
  { "B", "Wissen", "KL/KL/IN", "Sphärenkunde", false },
  { "A", "Wissen", "KL/KL/IN", "Sternkunde", false },

  # Talents: Crafting
  { "C", "Handwerk", "MU/KL/FF", "Alchimie", true },
  { "B", "Handwerk", "FF/GE/KK", "Boote & Schiffe", true },
  { "A", "Handwerk", "CH/FF/KO", "Fahrzeuge", true },
  { "B", "Handwerk", "KL/IN/CH", "Handel", false },
  { "B", "Handwerk", "MU/KL/IN", "Heilkunde Gift", true },
  { "B", "Handwerk", "MU/IN/KO", "Heilkunde Krankheiten", true },
  { "B", "Handwerk", "IN/CH/KO", "Heilkunde Seele", false },
  { "D", "Handwerk", "KL/FF/FF", "Heilkunde Wunden", true },
  { "B", "Handwerk", "FF/GE/KK", "Holzbearbeitung", true },
  { "A", "Handwerk", "IN/FF/FF", "Lebensmittelbearbeitung", true },
  { "B", "Handwerk", "FF/GE/KO", "Lederbearbeitung", true },
  { "A", "Handwerk", "IN/FF/FF", "Malen & Zeichnen", true },
  { "C", "Handwerk", "FF/KO/KK", "Metallbearbeitung", true },
  { "A", "Handwerk", "CH/FF/KO", "Musizieren", true },
  { "C", "Handwerk", "IN/FF/FF", "Schlösserknacken", true },
  { "A", "Handwerk", "FF/FF/KK", "Steinbearbeitung", true },
  { "A", "Handwerk", "KL/FF/FF", "Stoffbearbeitung", true }
]
|> Enum.each(& Dsa.Seed.skill(&1))

[
  # Close combat
  { "B", false, true, "GE", "Dolche", nil },
  { "C", false, true, "GE", "Fächer", nil },
  { "C", false, true, "GE", "Fechtwaffen", nil },
  { "C", false, true, "KK", "Hiebwaffen", nil },
  { "C", false, false, "KK", "Kettenwaffen", nil },
  { "B", false, true, "KK", "Lanzen", nil },
  { "B", false, false, "FF", "Peitschen", nil },
  { "B", false, true, "GE", "Raufen", "KK" },
  { "C", false, true, "KK", "Schilde", nil },
  { "C", false, true, "GE", "Schwerter", "KK" },
  { "C", false, false, "KK", "Spießwaffen", nil },
  { "C", false, true, "GE", "Stangenwaffen", "KK" },
  { "C", false, true, "KK", "Zweihandhiebwaffen", nil },
  { "C", false, true, "KK", "Zweihandschwerter", nil },

  # Ranged combat
  { "B", true, false, "FF", "Armbrüste", nil },
  { "B", true, false, "FF", "Blasrohre", nil },
  { "C", true, false, "FF", "Bögen", nil },
  { "C", true, false, "FF", "Diskusse", nil },
  { "B", true, false, "FF", "Feuerspeien", nil },
  { "B", true, false, "FF", "Schleudern", nil },
  { "B", true, false, "FF", "Wurfwaffen", nil }
]
|> Enum.each(& Dsa.Seed.combat_skill(&1))

alias Dsa.{Accounts, Repo}

# Create Admin User
{:ok, alex} = Accounts.register_user(%{
  name: "Alex",
  username: "admin",
  password: "p#7NDQ2y@0^f#WS3$j3u5@jPUjWcRlws"
})

Accounts.set_role(alex, :admin, true)

{:ok, group} =
  %Accounts.Group{}
  |> Accounts.Group.changeset(%{ name: "DSA", master_id: alex.id })
  |> Repo.insert()

Accounts.create_character(alex, %{
  name: "Rolo",
  species: "Mensch",
  culture: "Mittelreich",
  profession: "Rondrageweihter",
  group_id: group.id
})

Accounts.create_character(alex, %{
  name: "Sam",
  species: "Elf",
  culture: "Auelf",
  profession: "Wildnisläufer",
  group_id: group.id
})
