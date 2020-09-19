defmodule DsaWeb.CharacterHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """
  use Phoenix.HTML

  import Dsa.{Lists, Data}
  import DsaWeb.DsaHelpers

  alias Dsa.Data.{CombatSkill, CombatTrait, FateTrait, Script}

  def general_traits(c) do
    Enum.filter(c.character_traits, & Enum.member?(111..146, &1.trait_id))
  end

  def fate_traits(c) do
    Enum.filter(c.character_traits, & Enum.member?(147..152, &1.trait_id))
  end

  def staff_spells(c) do
    Enum.filter(c.character_traits, & Enum.member?(251..258, &1.trait_id))
  end

  def witchcraft(c) do
    Enum.filter(c.character_traits, & Enum.member?(261..262, &1.trait_id))
  end

  def blessings(c) do
    Enum.filter(c.character_traits, & Enum.member?(239..250, &1.trait_id))
  end

  def tricks(c) do
    Enum.filter(c.character_traits, & Enum.member?(223..234, &1.trait_id))
  end

  def ap(c) do

    base_values = Enum.map(base_values(), & ap_cost(Map.get(c, &1), "E")) |> Enum.sum()
    base_values = base_values - 8 * 8 * 15

    combat_skills =
      combat_fields()
      |> Enum.map(fn field ->
          id = Atom.to_string(field) |> String.slice(1, 2) |> String.to_integer()
          ap_cost(Map.get(c, field), CombatSkill.sf(id))
        end)
      |> Enum.sum()
    combat_skills = combat_skills - 9*12 - 12*18 # start value 6, 9 B talents, 12 C talents

    skills =
      talent_fields()
      |> Enum.map(fn field ->
          id = Atom.to_string(field) |> String.slice(1, 2) |> String.to_integer()
          ap_cost(Map.get(c, field), skill(id, :sf))
        end)
      |> Enum.sum()

    species = species(c.species_id, :ap)

    advantages = Enum.map(c.advantages, & &1.ap) |> Enum.sum()
    combat_traits = Enum.map(c.combat_traits, & CombatTrait.ap(&1.id)) |> Enum.sum()
    disadvantages = Enum.map(c.disadvantages, & &1.ap) |> Enum.sum()
    fate_traits = Enum.map(c.fate_traits, & FateTrait.ap(&1.id)) |> Enum.sum()
    general_traits = Enum.map(c.general_traits, & &1.ap) |> Enum.sum()
    languages = Enum.map(c.languages, & &1.level * 2) |> Enum.sum()
    scripts = Enum.map(c.scripts, & Script.ap(&1.script_id)) |> Enum.sum()

    magic_tradition =
      if c.magic_tradition_id, do: tradition(c.magic_tradition_id, :ap), else: 0

    karmal_tradition =
      if c.karmal_tradition_id, do: tradition(c.karmal_tradition_id, :ap), else: 0

    tricks = Enum.count(tricks(c))
    blessings = Enum.count(blessings(c))

    staffspells = c |> staff_spells() |> Enum.map(& &1.ap) |> Enum.sum()
    witchcraft = c |> witchcraft() |> Enum.map(& &1.ap) |> Enum.sum()

    spells =
      c.character_spells
      |> Enum.map(& ap_cost(&1.level, spell(&1.spell_id, :sf), true))
      |> Enum.sum()

    prayers =
      c.character_prayers
      |> Enum.map(& ap_cost(&1.level, prayer(&1.prayer_id, :sf), true))
      |> Enum.sum()

    le_bonus = ap_cost(Map.get(c, :le_bonus), "D")
    ae_bonus = ap_cost(Map.get(c, :ae_bonus), "D")
    ke_bonus = ap_cost(Map.get(c, :ke_bonus), "D")

    ae_back = ap_cost(Map.get(c, :ae_back), "D")
    ke_back = ap_cost(Map.get(c, :ke_back), "D")

    add_total(%{
      Eigenschaften: base_values,
      Vorteile: advantages,
      Nachteile: disadvantages,
      "Allgemeine SF": general_traits,
      "Kampf SF": combat_traits,
      "Schicksalspunkte SF": fate_traits,
      "Magische Tradition": magic_tradition,
      "Karmale Tradition": karmal_tradition,
      Zaubertricks: tricks,
      "Zaubersprüche / Rituale": spells,
      "Liturgien / Zeremonien": prayers,
      Sprachen: languages,
      Schriften: scripts,
      Segnungen: blessings,
      Spezies: species,
      Stabzauber: staffspells,
      Hexentricks: witchcraft,
      Talente: skills,
      Kampftalente: combat_skills,
      "Gekaufte LE": le_bonus,
      "Gekaufte AE": ae_bonus,
      "Gekaufte KE": ke_bonus,
      "Zurückgekaufte AE": ae_back,
      "Zurückgekaufte KE": ke_back
    })
  end

  defp add_total(map), do: Map.put(map, :total, Enum.sum(Map.values(map)))

  def ini(c) do
    basis = round((c.mu + c.ge) / 2)
    r1 = if Enum.find(c.combat_traits, & &1.id == 22), do: 1, else: 0
    r2 = if Enum.find(c.combat_traits, & &1.id == 23), do: 1, else: 0
    r3 = if Enum.find(c.combat_traits, & &1.id == 24), do: 1, else: 0
    add_total(%{"(MU+GE)/2": basis, Kampfreflexe: r1 + r2 + r3})
  end

  def aw(c) do
    basis = round(c.ge / 2)
    r1 = if Enum.find(c.combat_traits, & &1.id == 51), do: 1, else: 0
    r2 = if Enum.find(c.combat_traits, & &1.id == 52), do: 1, else: 0
    r3 = if Enum.find(c.combat_traits, & &1.id == 53), do: 1, else: 0
    add_total(%{"GE/2": basis, "Verbessertes Ausweichen": r1 + r2 + r3})
  end

  def gs(c) do
    advantages = if Enum.find(c.advantages, & &1.advantage_id == 9), do: 1, else: 0
    disadvantages = if Enum.find(c.disadvantages, & &1.disadvantage_id == 4), do: -1, else: 0
    species = species(c.species_id, :ge)
    add_total(%{Spezies: species, Flink: advantages, Behäbig: disadvantages})
  end

  def zk(c) do
    species = species(c.species_id, :zk)
    basis = round((c.ko * 2 + c.kk) / 6)
    advantages = if Enum.find(c.advantages, & &1.advantage_id == 24), do: 1, else: 0
    disadvantages = if Enum.find(c.disadvantages, & &1.disadvantage_id == 27), do: -1, else: 0

    add_total(%{
      Spezies: species,
      "(KO+KO+KK)/6": basis,
      "Hohe Zähigkeit": advantages,
      "Niedrige Zähigkeit": disadvantages
    })
  end

  def sk(c) do
    species = species(c.species_id, :sk)
    basis = round((c.mu + c.kl + c.in) / 6)
    advantages = if Enum.find(c.advantages, & &1.advantage_id == 23), do: 1, else: 0
    disadvantages = if Enum.find(c.disadvantages, & &1.disadvantage_id == 26), do: -1, else: 0
    add_total(%{
      Spezies: species,
      "(MU+KL+IN)/6": basis,
      "Hohe Seelenkraft": advantages,
      "Niedrige Seelenkraft": disadvantages
    })
  end

  def sp(c) do
    advantages =
      case Enum.find(c.advantages, & &1.advantage_id == 14) do
        nil -> 0
        advantage -> advantage.level
      end
    disadvantages =
      case Enum.find(c.disadvantages, & &1.disadvantage_id == 28) do
        nil -> 0
        disadvantage -> -disadvantage.level
      end

    add_total(%{Grundwert: 3, Glück: advantages, Pech: disadvantages})
  end

  def le(c) do
    species = species(c.species_id, :le)

    advantages =
      case Enum.find(c.advantages, & &1.advantage_id == 22) do
        nil -> 0
        advantage -> advantage.level
      end

    disadvantages =
      case Enum.find(c.disadvantages, & &1.disadvantage_id == 25) do
        nil -> 0
        disadvantage -> -disadvantage.level
      end

    add_total(%{
      Spezies: species,
      "2 x KO": 2 * c.ko,
      "Hohe Lebenskraft": advantages,
      "Perm. verloren": -c.le_lost,
      "Niedrige Lebenskraft": disadvantages,
      Zukauf: c.le_bonus
    })
  end

  def ae(c) do
    case Enum.find(c.character_traits, & &1.trait_id == 47) do
      nil ->
        %{total: 0}

      _ctrait ->
        {name, value} =
          case c.magic_tradition_id do
            nil ->
              {"-", 0}
            id ->
              name = tradition(id, :le)
              {name, Map.get(c, String.to_atom(name))}
          end

        advantages =
          case Enum.find(c.advantages, & &1.advantage_id == 20) do
            nil -> 0
            advantage -> advantage.level
          end
        disadvantages =
          case Enum.find(c.disadvantages, & &1.disadvantage_id == 23) do
            nil -> 0
            disadvantage -> -disadvantage.level
          end

        lost = c.ae_lost - c.ae_back
        add_total(%{
          Zauberer: 20,
          "Leiteigenschaft #{name}": value,
          "Hohe Astralkraft": advantages,
          "Niedrige Astralkraft": disadvantages,
          "Perm. verloren": -lost,
          Zukauf: c.ae_bonus
        })
    end
  end

  def ke(c) do
    case Enum.find(c.character_traits, & &1.trait_id == 12) do
      nil ->
        %{ total: 0 }

      _ctrait ->
        {name, value} =
          case c.karmal_tradition_id do
            nil ->
              {"-", 0}
            id ->
              name = tradition(id, :le)
              {name, Map.get(c, String.downcase(name) |> String.to_atom())}
          end

        advantages =
          case Enum.find(c.advantages, & &1.advantage_id == 21) do
            nil -> 0
            advantage -> advantage.level
          end
        disadvantages =
          case Enum.find(c.disadvantages, & &1.disadvantage_id == 24) do
            nil -> 0
            disadvantage -> -disadvantage.level
          end

        lost = c.ke_lost - c.ke_back

        add_total(%{
          Gelehrter: 20,
          "Leiteigenschaft #{name}": value,
          "Hohe Karmalkraft": advantages,
          "Niedrige Karmalkraft": disadvantages,
          "Perm. verloren": -lost,
          Zukauf: c.ke_bonus
        })
    end
  end

  def at(c, id) do
    case CombatSkill.ranged(id) do
      true -> Map.get(c, String.to_atom("c#{id}")) + max(0, floor((c.ff - 8)/3))
      false -> Map.get(c, String.to_atom("c#{id}")) + max(0, floor((c.mu - 8)/3))
    end
  end

  def pa(c, id) do
    bonus =
      cond do
        not CombatSkill.parade(id) -> nil
        CombatSkill.ge(id) && CombatSkill.kk(id) -> max(c.kk, c.ge)
        CombatSkill.ge(id) -> c.ge
        CombatSkill.kk(id) -> c.kk
        true -> nil
      end
    case bonus do
      nil -> nil
      bonus -> round(Map.get(c, String.to_atom("c#{id}"))/2 + max(0, floor((bonus - 8)/3)))
    end
  end

  def probe_values(probe, character) do
    probe
    |> String.downcase()
    |> String.split("/")
    |> Enum.map(& Map.get(character, String.to_atom(&1)))
  end

  def tooltip_text(stat) do
    Enum.map(stat, fn {key, value} ->
      cond do
        key == :total -> nil
        value == 0 -> nil
        value > 0 -> "#{key}: <span class='badge bg-success'>#{value}</span>"
        value < 0 -> "#{key}: <span class='badge bg-danger'>#{value}</span>"
      end
    end)
    |> Enum.reject(& is_nil(&1))
    |> Enum.join("<br>")
  end
end
