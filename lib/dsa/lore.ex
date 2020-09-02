defmodule Dsa.Lore do
  @moduledoc """
  The Lore context.
  """
  import Ecto.Query, warn: false
  require Logger

  alias Dsa.Repo
  alias Dsa.Lore.{Armor, CombatSkill, SpecialSkill, Skill, Weapon}

  def list_armors, do: Repo.all(from(s in Armor, order_by: s.name))

  def armor_options, do: Repo.all(from(a in Armor, select: {a.name, a.id}, order_by: a.name))

  def list_skills, do: Repo.all(from(s in Skill, order_by: [s.category, s.name]))

  def change_skill(skill, attrs \\ %{}), do: Skill.changeset(skill, attrs)

  def list_combat_skills, do: Repo.all(from(s in CombatSkill, order_by: [s.ranged, s.name]))

  def list_special_skills, do: Repo.all(from(s in SpecialSkill, preload: :combat_skills, order_by: s.name))

  def list_weapons do
    Repo.all(from(w in Weapon, preload: :combat_skill, order_by: [w.combat_skill_id, w.name]))
  end

  def cast_options do
    from(s in Skill,
      select: {s.name, s.id},
      order_by: s.name,
      where: s.category == "Zauber" or s.category == "Liturgie"
    ) |> Repo.all()
  end

  def seed(:armors) do
    [
      { 1, "Schwere Kleidung", 1, 0, true },
      { 2, "Winterkleidung", 1, 0, true },
      { 3, "Iryanrüstung", 3, 1, true },
      { 4, "Kettenhemd", 4, 2, false },
      { 5, "Krötenhaut", 3, 1, true },
      { 6, "Lederharnisch", 3, 1, true },
      { 7, "Leichte Platte", 6, 3, false },
      { 8, "Schuppenpanzer", 5, 2, true },
      { 9, "Spiegelpanzer", 4, 2, false },
      { 10, "Tuchrüstung", 2, 1, false }
    ]
    |> Enum.each(fn {id, name, rs, be, penalties} ->
      case Repo.get(Armor, id) do
        nil  -> %Armor{id: id}
        entry -> entry
      end
      |> Armor.changeset(%{id: id, name: name, rs: rs, be: be, penalties: penalties})
      |> Repo.insert_or_update!()

      Logger.debug("Armor: #{name} updated...")
    end)
  end

  def seed(:combat_skills) do
    [
      # Close combat
      { 1, "B", false, true, "GE", "Dolche", nil },
      { 2, "C", false, true, "GE", "Fächer", nil },
      { 3, "C", false, true, "GE", "Fechtwaffen", nil },
      { 4, "C", false, true, "KK", "Hiebwaffen", nil },
      { 5, "C", false, false, "KK", "Kettenwaffen", nil },
      { 6, "B", false, true, "KK", "Lanzen", nil },
      { 7, "B", false, false, "FF", "Peitschen", nil },
      { 8, "B", false, true, "GE", "Raufen", "KK" },
      { 9, "C", false, true, "KK", "Schilde", nil },
      { 10, "C", false, true, "GE", "Schwerter", "KK" },
      { 11, "C", false, false, "KK", "Spießwaffen", nil },
      { 12, "C", false, true, "GE", "Stangenwaffen", "KK" },
      { 13, "C", false, true, "KK", "Zweihandhiebwaffen", nil },
      { 14, "C", false, true, "KK", "Zweihandschwerter", nil },
      # Ranged combat
      { 15, "B", true, false, "FF", "Armbrüste", nil },
      { 16, "B", true, false, "FF", "Blasrohre", nil },
      { 17, "C", true, false, "FF", "Bögen", nil },
      { 18, "C", true, false, "FF", "Diskusse", nil },
      { 19, "B", true, false, "FF", "Feuerspeien", nil },
      { 20, "B", true, false, "FF", "Schleudern", nil },
      { 21, "B", true, false, "FF", "Wurfwaffen", nil }
    ]
    |> Enum.each(fn {id, sf, ranged, parade, e1, name, e2} ->
      case Repo.get(CombatSkill, id) do
        nil  -> %CombatSkill{id: id}
        entry -> entry
      end
      |> CombatSkill.changeset(%{
        id: id,
        name: name,
        ranged: ranged,
        parade: parade,
        e1: e1,
        e2: e2,
        sf: sf
      })
      |> Repo.insert_or_update!()

      Logger.debug("Combat Skill: #{name} updated...")
    end)
  end

  def seed(:skills) do
    [
      # Körper
      { 1, "B", "Körper", "MU/IN/GE", "Fliegen", true },
      { 2, "A", "Körper", "MU/CH/FF", "Gaukeleien", true },
      { 3, "B", "Körper", "MU/GE/KK", "Klettern", true },
      { 4, "D", "Körper", "GE/GE/KO", "Körperbeherrschung", true },
      { 5, "B", "Körper", "KO/KK/KK", "Kraftakt", true },
      { 6, "B", "Körper", "CH/GE/KK", "Reiten", true },
      { 7, "B", "Körper", "GE/KO/KK", "Schwimmen", true },
      { 8, "D", "Körper", "MU/MU/KO", "Selbstbeherrschung", false },
      { 9, "A", "Körper", "KL/CH/KO", "Singen", nil },
      { 10, "D", "Körper", "KL/IN/IN", "Sinnesschärfe", nil },
      { 11, "A", "Körper", "KL/CH/GE", "Tanzen", true },
      { 12, "B", "Körper", "MU/FF/GE", "Taschendiebstahl", true },
      { 13, "C", "Körper", "MU/IN/GE", "Verbergen", true },
      { 14, "A", "Körper", "KL/KO/KK", "Zechen", false },

      # Gesellschaft
      { 15, "B", "Gesellschaft", "MU/KL/CH", "Bekehren / Überzeugen", false },
      { 16, "B", "Gesellschaft", "MU/CH/CH", "Betören", nil },
      { 17, "B", "Gesellschaft", "MU/IN/CH", "Einschüchtern", false },
      { 18, "B", "Gesellschaft", "KL/IN/CH", "Etikette", nil },
      { 19, "C", "Gesellschaft", "KL/IN/CH", "Gassenwissen", nil },
      { 20, "C", "Gesellschaft", "KL/IN/CH", "Menschenkenntnis", false },
      { 21, "C", "Gesellschaft", "MU/IN/CH", "Überreden", false },
      { 22, "B", "Gesellschaft", "IN/CH/GE", "Verkleiden", nil },
      { 23, "D", "Gesellschaft", "MU/IN/CH", "Willenskraft", false },

      # Talents: Nature
      { 24, "C", "Natur", "MU/IN/CH", "Fährtensuchen", true },
      { 25, "A", "Natur", "KL/FF/KK", "Fesseln", nil },
      { 26, "A", "Natur", "FF/GE/KO", "Fischen & Angeln", nil },
      { 27, "B", "Natur", "KL/IN/IN", "Orientierung", false },
      { 28, "C", "Natur", "KL/FF/KO", "Pflanzenkunde", nil },
      { 29, "C", "Natur", "MU/MU/CH", "Tierkunde", true },
      { 30, "C", "Natur", "MU/GE/KO", "Wildnisleben", true },

      # Talents: Knowledge
      { 31, "A", "Wissen", "KL/KL/IN", "Brett- & Glücksspiel", false },
      { 32, "B", "Wissen", "KL/KL/IN", "Geographie", false },
      { 33, "B", "Wissen", "KL/KL/IN", "Geschichtswissen", false },
      { 34, "B", "Wissen", "KL/KL/IN", "Götter & Kulte", false },
      { 35, "B", "Wissen", "MU/KL/IN", "Kriegskunst", false },
      { 36, "C", "Wissen", "KL/KL/IN", "Magiekunde", false },
      { 37, "B", "Wissen", "KL/KL/FF", "Mechanik", false },
      { 38, "A", "Wissen", "KL/KL/IN", "Rechnen", false },
      { 39, "A", "Wissen", "KL/KL/IN", "Rechtskunde", false },
      { 40, "B", "Wissen", "KL/KL/IN", "Sagen & Legenden", false },
      { 41, "B", "Wissen", "KL/KL/IN", "Sphärenkunde", false },
      { 42, "A", "Wissen", "KL/KL/IN", "Sternkunde", false },

      # Talents: Crafting
      { 43, "C", "Handwerk", "MU/KL/FF", "Alchimie", true },
      { 44, "B", "Handwerk", "FF/GE/KK", "Boote & Schiffe", true },
      { 45, "A", "Handwerk", "CH/FF/KO", "Fahrzeuge", true },
      { 46, "B", "Handwerk", "KL/IN/CH", "Handel", false },
      { 47, "B", "Handwerk", "MU/KL/IN", "Heilkunde Gift", true },
      { 48, "B", "Handwerk", "MU/IN/KO", "Heilkunde Krankheiten", true },
      { 49, "B", "Handwerk", "IN/CH/KO", "Heilkunde Seele", false },
      { 50, "D", "Handwerk", "KL/FF/FF", "Heilkunde Wunden", true },
      { 51, "B", "Handwerk", "FF/GE/KK", "Holzbearbeitung", true },
      { 52, "A", "Handwerk", "IN/FF/FF", "Lebensmittelbearbeitung", true },
      { 53, "B", "Handwerk", "FF/GE/KO", "Lederbearbeitung", true },
      { 54, "A", "Handwerk", "IN/FF/FF", "Malen & Zeichnen", true },
      { 55, "C", "Handwerk", "FF/KO/KK", "Metallbearbeitung", true },
      { 56, "A", "Handwerk", "CH/FF/KO", "Musizieren", true },
      { 57, "C", "Handwerk", "IN/FF/FF", "Schlösserknacken", true },
      { 59, "A", "Handwerk", "FF/FF/KK", "Steinbearbeitung", true }
    ]
    |> Enum.each(fn {id, sf, category, probe, name, be} ->
      [e1, e2, e3] =
        case String.split(probe, "/") do
          [e1] -> [e1, nil, nil]
          [e1, e2] -> [e1, e2, nil]
          [e1, e2, e3] -> [e1, e2, e3]
        end

      case Repo.get(Skill, id) do
        nil  -> %Skill{id: id}
        entry -> entry
      end
      |> Skill.changeset(%{
        name: name,
        category: category,
        e1: e1,
        e2: e2,
        e3: e3,
        be: be,
        sf: sf
      })
      |> Repo.insert_or_update!()

      Logger.debug("Skill: #{name} updated...")
    end)
  end

  def seed(:weapons) do
    [
    ]
    |> Enum.each(fn {id, name} ->
      case Repo.get(Weapon, id) do
        nil  -> %Weapon{id: id}
        entry -> entry
      end
      |> Weapon.changeset(%{id: id, name: name})
      |> Repo.insert_or_update!()

      Logger.debug("Weapon: #{name} updated...")
    end)
  end

  def seed(:special_skills) do
    SpecialSkill.entries()
    |> Enum.each(fn {%{id: id, name: name} = params, combat_skills} ->

      combat_skills = Repo.all(from(s in CombatSkill, where: s.id in ^combat_skills))

      case Repo.get(SpecialSkill, id) do
        nil  -> %SpecialSkill{id: id}
        entry -> Repo.preload(entry, :combat_skills)
      end
      |> SpecialSkill.changeset(params)
      |> Ecto.Changeset.put_assoc(:combat_skills, combat_skills)
      |> Repo.insert_or_update!()

      Logger.debug("Special Skill: #{name} updated...")
    end)
  end
end
