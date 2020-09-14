defmodule DsaWeb.CharacterHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """
  use Phoenix.HTML

  import Dsa.{Lists, Data}
  import DsaWeb.DsaHelpers

  def advantages(character) do
    Enum.filter(character.character_traits, & Enum.member?(1..50, &1.trait_id))
  end

  def disadvantages(character) do
    Enum.filter(character.character_traits, & Enum.member?(51..110, &1.trait_id))
  end

  def general_traits(c) do
    Enum.filter(c.character_traits, & Enum.member?(111..146, &1.trait_id))
  end

  def fate_traits(c) do
    Enum.filter(c.character_traits, & Enum.member?(147..152, &1.trait_id))
  end

  def combat_traits(c) do
    Enum.filter(c.character_traits, & Enum.member?(153..217, &1.trait_id))
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
          ap_cost(Map.get(c, field), combat_skill(id, :sf))
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
    advantages = c |> advantages() |> Enum.map(& &1.ap) |> Enum.sum()
    disadvantages = c |> disadvantages() |> Enum.map(& &1.ap) |> Enum.sum()
    general_traits = c |> general_traits() |> Enum.map(& &1.ap) |> Enum.sum()
    combat_traits = c |> combat_traits() |> Enum.map(& &1.ap) |> Enum.sum()
    fate_traits = c |> fate_traits() |> Enum.map(& &1.ap) |> Enum.sum()

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

    %{
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
      "Zurückgekaufte KE": ke_back,
      total: base_values + advantages + disadvantages + le_bonus + ae_bonus + ke_bonus + combat_traits + general_traits + fate_traits + magic_tradition + karmal_tradition + tricks + blessings + combat_skills + skills + species + witchcraft + staffspells + ae_back + ke_back + spells + prayers
    }
  end

  defp trait_level(c, id) do
    case Enum.find(c.character_traits, & &1.trait_id == id) do
      nil -> 0
      trait -> trait.level
    end
  end

  defp has_trait?(c, id) do
    if Enum.find(c.character_traits, & &1.trait_id == id), do: true, else: false
  end

  def ini(c) do
    basis = round((c.mu + c.ge) / 2)
    r1 = if has_trait?(c, "Kampfreflexe I"), do: 1, else: 0
    r2 = if has_trait?(c, "Kampfreflexe II"), do: 1, else: 0
    r3 = if has_trait?(c, "Kampfreflexe III"), do: 1, else: 0
    %{
      Basis: basis,
      Kampfreflexe: r1 + r2 + r3,
      total: basis + r1 + r2 + r3
    }
  end

  def aw(c) do
    basis = round(c.ge / 2)
    r1 = if has_trait?(c, "Verbessertes Ausweichen I"), do: 1, else: 0
    r2 = if has_trait?(c, "Verbessertes Ausweichen II"), do: 1, else: 0
    r3 = if has_trait?(c, "Verbessertes Ausweichen III"), do: 1, else: 0
    %{
      Basis: basis,
      "Verbessertes Ausweichen": r1 + r2 + r3,
      total: basis + r1 + r2 + r3
    }
  end

  def gs(c) do
    advantages = if has_trait?(c, 9), do: 1, else: 0
    disadvantages = if has_trait?(c, 54), do: 1, else: 0
    species = species(c.species_id, :ge)
    %{
      Spezies: species,
      Flink: advantages,
      Behäbig: disadvantages,
      total: species + advantages + disadvantages
    }
  end

  def zk(c) do
    species = species(c.species_id, :zk)
    basis = round((c.ko * 2 + c.kk) / 6)
    advantages = if has_trait?(c, 24), do: 1, else: 0
    disadvantages = if has_trait?(c, 86), do: 1, else: 0

    %{
      Spezies: species,
      "(KO+KO+KK)/6": basis,
      "Hohe Zähigkeit": advantages,
      "Niedrige Zähigkeit": disadvantages,
      total: species + basis + advantages + disadvantages
    }
  end

  def sk(c) do
    species = species(c.species_id, :sk)
    basis = round((c.mu + c.kl + c.in) / 6)
    advantages = if has_trait?(c, 23), do: 1, else: 0
    disadvantages = if has_trait?(c, 85), do: 1, else: 0
    %{
      Spezies: species,
      "(MU+KL+IN)/6": basis,
      "Hohe Seelenkraft": advantages,
      "Niedrige Seelenkraft": disadvantages,
      total: species + basis + advantages + disadvantages
    }
  end

  def sp(c) do
    advantages = trait_level(c, 14)
    disadvantages = trait_level(c, 87) * -1
    %{
      Grundwert: 3,
      Glück: advantages,
      Pech: disadvantages,
      total: 3 + advantages + disadvantages
    }
  end

  def le(c) do
    species = species(c.species_id, :le)
    advantages = trait_level(c, 22)
    disadvantages = trait_level(c, 84) * -1

    %{
      Spezies: species,
      "2 x KO": 2 * c.ko,
      "Hohe Lebenskraft": advantages,
      "Perm. verloren": -c.le_lost,
      "Niedrige Lebenskraft": disadvantages,
      Zukauf: c.le_bonus,
      total: species + 2 * c.ko + advantages + disadvantages + c.le_bonus - c.le_lost
    }
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

        advantages = trait_level(c, 20)
        disadvantages = trait_level(c, 82) * -1
        lost = c.ae_lost - c.ae_back
        %{
          Zauberer: 20,
          "Leiteigenschaft #{name}": value,
          "Hohe Astralkraft": advantages,
          "Niedrige Astralkraft": disadvantages,
          "Perm. verloren": -lost,
          Zukauf: c.ae_bonus,
          total: 20 + value + advantages + disadvantages + c.ae_bonus - lost
        }
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

        advantages = trait_level(c, 21)
        disadvantages = trait_level(c, 83) * -1
        lost = c.ke_lost - c.ke_back

        %{
          Gelehrter: 20,
          "Leiteigenschaft #{name}": value,
          "Hohe Karmalkraft": advantages,
          "Niedrige Karmalkraft": disadvantages,
          "Perm. verloren": -lost,
          Zukauf: c.ke_bonus,
          total: 20 + value + advantages + disadvantages + c.ke_bonus - lost
        }
    end
  end

  def at(c, id) do
    case combat_skill(id, :ranged) do
      true -> Map.get(c, String.to_atom("c#{id}")) + max(0, floor((c.ff - 8)/3))
      false -> Map.get(c, String.to_atom("c#{id}")) + max(0, floor((c.mu - 8)/3))
    end
  end

  def pa(c, id) do
    bonus =
      cond do
        not combat_skill(id, :parade) -> nil
        combat_skill(id, :ge) && combat_skill(id, :kk) -> max(c.kk, c.ge)
        combat_skill(id, :ge) -> c.ge
        combat_skill(id, :kk) -> c.kk
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
