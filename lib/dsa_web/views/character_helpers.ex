defmodule DsaWeb.CharacterHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """
  use Phoenix.HTML
  import Dsa.Lists
  import DsaWeb.DsaHelpers

  def advantages(character) do
    Enum.filter(character.character_traits, & &1.trait.level > 0 && &1.trait.ap > 0)
  end

  def disadvantages(character) do
    Enum.filter(character.character_traits, & &1.trait.level > 0 && &1.trait.ap < 0)
  end

  def general_traits(char), do: Enum.filter(char.character_traits, & &1.trait.level == 0)
  def fate_traits(char), do: Enum.filter(char.character_traits, & &1.trait.level == -1)
  def traditions(char), do: Enum.filter(char.character_traits, & &1.trait.level == -2)
  def combat_traits(char), do: Enum.filter(char.character_traits, & &1.trait.level == -3)
  def blessings(char), do: Enum.filter(char.character_traits, & &1.level == -7)
  def tricks(char), do: Enum.filter(char.character_traits, & &1.level == -6)


  def ap(c) do

    base_values = Enum.map(base_values(), & ap_cost(Map.get(c, &1), "E")) |> Enum.sum()
    base_values = base_values - 8 * 8 * 15

    advantages = c |> advantages() |> Enum.map(& &1.ap) |> Enum.sum()
    disadvantages = c |> disadvantages() |> Enum.map(& &1.ap) |> Enum.sum()
    general_traits = c |> general_traits() |> Enum.map(& &1.ap) |> Enum.sum()
    combat_traits = c |> combat_traits() |> Enum.map(& &1.ap) |> Enum.sum()
    fate_traits = c |> fate_traits() |> Enum.map(& &1.ap) |> Enum.sum()
    traditions = c |> traditions() |> Enum.map(& &1.ap) |> Enum.sum()
    tricks = Enum.count(tricks(c))
    blessings = Enum.count(blessings(c))
    skills = Enum.map(c.character_skills, & ap_cost(&1.level, &1.skill.sf)) |> Enum.sum()

    combat_skills = Enum.map(c.character_combat_skills, & ap_cost(&1.level, &1.combat_skill.sf))
    |> Enum.sum()
    combat_skills = combat_skills - 9*12 - 12*18 # start value 6, 9 B talents, 12 C talents

    energies =
      ap_cost(Map.get(c, :le_bonus), "D") +
      ap_cost(Map.get(c, :ae_bonus), "D") +
      ap_cost(Map.get(c, :ke_bonus), "D")

    %{
      Eigenschaften: base_values,
      Vorteile: advantages,
      Nachteile: disadvantages,
      Energien: energies,
      "Allgemeine SF": general_traits,
      "Kampf SF": combat_traits,
      "Schicksalspunkte SF": fate_traits,
      Traditionen: traditions,
      Zaubertricks: tricks,
      Segnungen: blessings,
      Talente: skills,
      Kampftalente: combat_skills,
      total: base_values + advantages + disadvantages + energies + combat_traits + general_traits + fate_traits + traditions + tricks + blessings + combat_skills
    }
  end

  defp trait_level(c, trait) do
    case Enum.find(c.character_traits, & &1.trait.name == trait) do
      nil -> 0
      trait -> trait.level
    end
  end

  defp has_trait?(c, trait) do
    if Enum.find(c.character_traits, & &1.trait.name == trait), do: true, else: false
  end

  def ini(c) do
    basis = round((Map.get(c, :MU) + Map.get(c, :GE)) / 2)
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
    basis = round(Map.get(c, :GE) / 2)
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
    advantages = if has_trait?(c, "Flink"), do: 1, else: 0
    disadvantages = if has_trait?(c, "Behäbig"), do: 1, else: 0
    basis = c.species.gs
    %{
      Basis: basis,
      Flink: advantages,
      Behäbig: disadvantages,
      total: basis + advantages + disadvantages
    }
  end

  def zk(c) do
    species = c.species.zk
    basis = round((Map.get(c, :KO) * 2 + Map.get(c, :KK)) / 6)
    advantages = if has_trait?(c, "Hohe Zähigkeit"), do: 1, else: 0
    disadvantages = if has_trait?(c, "Niedrige Zähigkeit"), do: 1, else: 0
    %{
      Spezies: species,
      "(KO+KO+KK)/6": basis,
      "Hohe Zähigkeit": advantages,
      "Niedrige Zähigkeit": disadvantages,
      total: species + basis + advantages + disadvantages
    }
  end

  def sk(c) do
    species = c.species.sk
    basis = round((Map.get(c, :MU) + Map.get(c, :KL) + Map.get(c, :IN)) / 6)
    advantages = if has_trait?(c, "Hohe Seelenkraft"), do: 1, else: 0
    disadvantages = if has_trait?(c, "Niedrige Seelenkraft"), do: 1, else: 0
    %{
      Spezies: species,
      "(MU+KL+IN)/6": basis,
      "Hohe Seelenkraft": advantages,
      "Niedrige Seelenkraft": disadvantages,
      total: species + basis + advantages + disadvantages
    }
  end

  def sp(c) do
    advantages = trait_level(c, "Glück")
    disadvantages = trait_level(c, "Pech") * -1
    %{
      Grundwert: 3,
      Glück: advantages,
      Pech: disadvantages,
      total: 3 + advantages + disadvantages
    }
  end

  def le(c) do
    species = c.species.le
    ko = 2 * Map.get(c, :KO)
    bonus = Map.get(c, :le_bonus)
    advantages = trait_level(c, "Hohe Lebenskraft")
    disadvantages = trait_level(c, "Niedrige Lebenskraft") * -1
    %{
      Spezies: species,
      "2 x KO": ko,
      "Hohe Lebenskraft": advantages,
      "Niedrige Lebenskraft": disadvantages,
      Zukauf: bonus,
      total: species + ko + advantages + disadvantages + bonus
    }
  end

  def ae(c) do
    case Enum.find(c.character_traits, & &1.trait.name == "Zauberer") do
      nil ->
        %{total: 0}

      _ctrait ->
        ltrait_name =
          cond do
            has_trait?(c, "Tradition (Hexe)") -> :CH
            has_trait?(c, "Tradition (Elf)") -> :IN
            true -> :KL
          end
        ltrait_value = Map.get(c, ltrait_name)
        bonus = Map.get(c, :ae_bonus)
        advantages = trait_level(c, "Hohe Astralkraft")
        disadvantages = trait_level(c, "Niedrige Astralkraft") * -1
        %{
          Zauberer: 20,
          "Leiteigenschaft #{ltrait_name}": ltrait_value,
          "Hohe Astralkraft": advantages,
          "Niedrige Astralkraft": disadvantages,
          Zukauf: bonus,
          total: 20 + ltrait_value + advantages + disadvantages + bonus
        }
    end
  end

  def ke(c) do
    case Enum.find(c.character_traits, & &1.trait.name == "Geweihter") do
      nil ->
        %{ total: 0 }

      _ctrait ->
        ltrait_name =
          cond do
            has_trait?(c, "Tradition (Praioskirche)") -> :KL
            has_trait?(c, "Tradition (Rondrakirche)") -> :MU
            has_trait?(c, "Tradition (Boronkirche)") -> :MU
            has_trait?(c, "Tradition (Hesindekirche)") -> :KL
            has_trait?(c, "Tradition (Phexkirche)") -> :IN
            has_trait?(c, "Tradition (Perainekirche)") -> :IN
            true -> :KL
          end

        ltrait_value = Map.get(c, ltrait_name)
        bonus = Map.get(c, :ke_bonus)
        advantages = trait_level(c, "Hohe Karmalkraft")
        disadvantages = trait_level(c, "Niedrige Karmalkraft") * -1
        %{
          Gelehrter: 20,
          "Leiteigenschaft #{ltrait_name}": ltrait_value,
          "Hohe Karmalkraft": advantages,
          "Niedrige Karmalkraft": disadvantages,
          Zukauf: bonus,
          total: 20 + ltrait_value + advantages + disadvantages + bonus
        }
    end
  end

  def at(c, cskill) do
    case cskill.combat_skill.ranged do
      true -> cskill.level + max(0, floor((Map.get(c, :FF) - 8)/3))
      false -> cskill.level + max(0, floor((Map.get(c, :MU) - 8)/3))
    end
  end

  def pa(c, cskill) do
    bonus =
      cond do
        not cskill.combat_skill.parade -> nil
        cskill.combat_skill.ge && cskill.combat_skill.kk -> max(Map.get(c, :KK), Map.get(c, :GE))
        cskill.combat_skill.ge -> Map.get(c, :GE)
        cskill.combat_skill.kk -> Map.get(c, :KK)
        true -> nil
      end
    case bonus do
      nil -> nil
      bonus -> round(cskill.level/2 + max(0, floor((bonus - 8)/3)))
    end
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
