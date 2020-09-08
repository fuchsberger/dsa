defmodule DsaWeb.CharacterHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """
  use Phoenix.HTML
  import Ecto.Changeset, only: [get_field: 2]

  def advantages(character) do
    Enum.filter(character.character_traits, & &1.trait.level > 0 && &1.trait.ap > 0)
  end

  def disadvantages(character) do
    Enum.filter(character.character_traits, & &1.trait.level > 0 && &1.trait.ap < 0)
  end

  def general_skills(character) do
    Enum.filter(character.character_traits, & &1.trait.level == 0)
  end

  def fate_skills(character) do
    Enum.filter(character.character_traits, & &1.trait.level == -1)
  end

  def traditions(character) do
    Enum.filter(character.character_traits, & &1.trait.level == -2)
  end

  def ap(character) do

    advantages =
      character
      |> advantages()
      |> Enum.map(& &1.ap)
      |> Enum.sum()

    disadvantages =
      character
      |> disadvantages()
      |> Enum.map(& &1.ap)
      |> Enum.sum()

    general_skills =
      character
      |> general_skills()
      |> Enum.map(& &1.ap)
      |> Enum.sum()

    fate_skills =
      character
      |> fate_skills()
      |> Enum.map(& &1.ap)
      |> Enum.sum()

    traditions =
      character
      |> traditions()
      |> Enum.map(& &1.ap)
      |> Enum.sum()

    %{
      Vorteile: advantages,
      Nachteile: disadvantages,
      "Allgemeine SF": general_skills,
      "Schicksalspunkte SF": fate_skills,
      Traditionen: traditions,
      total: advantages + disadvantages + general_skills + fate_skills + traditions
    }
  end

  def ini(character) do
    basis = round((Map.get(character, :MU) + Map.get(character, :GE)) / 2)

    r1 =
      case Enum.find(character.special_skills, & &1.skill.name == "Kampfreflexe I") do
        nil -> 0
        _skill -> 1
      end
    r2 =
      case Enum.find(character.special_skills, & &1.skill.name == "Kampfreflexe II") do
        nil -> 0
        _skill -> 1
      end
    r3 =
      case Enum.find(character.special_skills, & &1.skill.name == "Kampfreflexe III") do
        nil -> 0
        _skill -> 1
      end

    %{
      Basis: basis,
      Kampfreflexe: r1 + r2 + r3,
      total: basis + r1 + r2 + r3
    }
  end

  def aw(character) do
    basis = round(Map.get(character, :GE) / 2)

    r1 =
      case Enum.find(character.special_skills, & &1.skill.name == "Verbessertes Ausweichen I") do
        nil -> 0
        _skill -> 1
      end
    r2 =
      case Enum.find(character.special_skills, & &1.skill.name == "Verbessertes Ausweichen II") do
        nil -> 0
        _skill -> 1
      end
    r3 =
      case Enum.find(character.special_skills, & &1.skill.name == "Verbessertes Ausweichen III") do
        nil -> 0
        _skill -> 1
      end

    %{
      Basis: basis,
      "Verbessertes Ausweichen": r1 + r2 + r3,
      total: basis + r1 + r2 + r3
    }
  end

  def gs(character) do
    advantages =
      case Enum.find(character.character_traits, & &1.trait.name == "Flink") do
        nil -> 0
        _ctrait -> 1
      end

    disadvantages =
      case Enum.find(character.character_traits, & &1.trait.name == "Behäbig") do
        nil -> 0
        _ctrait -> -1
      end


    basis = character.species.gs
    %{
      Basis: basis,
      Flink: advantages,
      Behäbig: disadvantages,
      total: basis + advantages + disadvantages
    }
  end

  def zk(character) do
    species = character.species.zk
    basis = round((Map.get(character, :KO) * 2 + Map.get(character, :KK)) / 6)

    advantages =
      case Enum.find(character.character_traits, & &1.trait.name == "Hohe Zähigkeit") do
        nil -> 0
        _ctrait -> 1
      end

    disadvantages =
      case Enum.find(character.character_traits, & &1.trait.name == "Niedrige Zähigkeit") do
        nil -> 0
        _ctrait -> -1
      end

    %{
      Spezies: species,
      "(KO+KO+KK) / 6": basis,
      "Hohe Zähigkeit": advantages,
      "Niedrige Zähigkeit": disadvantages,
      total: species + basis + advantages + disadvantages
    }
  end

  def sk(character) do
    species = character.species.sk
    basis = round((Map.get(character, :MU) + Map.get(character, :KL) + Map.get(character, :IN)) / 6)

    advantages =
      case Enum.find(character.character_traits, & &1.trait.name == "Hohe Seelenkraft") do
        nil -> 0
        _ctrait -> 1
      end

    disadvantages =
      case Enum.find(character.character_traits, & &1.trait.name == "Niedrige Seelenkraft") do
        nil -> 0
        _ctrait -> -1
      end

    %{
      Spezies: species,
      "(MU+KL+IN) / 6": basis,
      "Hohe Seelenkraft": advantages,
      "Niedrige Seelenkraft": disadvantages,
      total: species + basis + advantages + disadvantages
    }
  end

  def sp(character) do
    advantages =
      case Enum.find(character.character_traits, & &1.trait.name == "Glück") do
        nil -> 0
        ctrait -> ctrait.level
      end

    disadvantages =
      case Enum.find(character.character_traits, & &1.trait.name == "Pech") do
        nil -> 0
        ctrait -> ctrait.level * -1
      end

    %{
      Grundwert: 3,
      Glück: advantages,
      Pech: disadvantages,
      total: 3 + advantages + disadvantages
    }
  end

  def le(character) do
    species = character.species.le
    ko = 2 * Map.get(character, :KO)
    bonus = Map.get(character, :le_bonus)
    advantages =
      case Enum.find(character.character_traits, & &1.trait.name == "Hohe Lebenskraft") do
        nil -> 0
        ctrait -> ctrait.level
      end

    disadvantages =
      case Enum.find(character.character_traits, & &1.trait.name == "Niedrige Lebenskraft") do
        nil -> 0
        ctrait -> ctrait.level * -1
      end

    %{
      Spezies: species,
      "2 x KO": ko,
      "Hohe Lebenskraft": advantages,
      "Niedrige Lebenskraft": disadvantages,
      Zukauf: bonus,
      total: species + ko + advantages + disadvantages + bonus
    }
  end

  def ae(character) do
    case Enum.find(character.character_traits, & &1.trait.name == "Zauberer") do
      nil ->
        %{total: 0}

      _ctrait ->
        ltrait_name =
          cond do
            Enum.find(character.character_traits, & &1.trait.name == "Tradition (Hexe)") -> :CH
            Enum.find(character.character_traits, & &1.trait.name == "Tradition (Elf)") -> :IN
            true -> :KL
          end

        ltrait_value = Map.get(character, ltrait_name)

        bonus = Map.get(character, :ae_bonus)

        advantages =
          case Enum.find(character.character_traits, & &1.trait.name == "Hohe Astralkraft") do
            nil -> 0
            ctrait -> ctrait.level
          end

        disadvantages =
          case Enum.find(character.character_traits, & &1.trait.name == "Niedrige Astralkraft") do
            nil -> 0
            ctrait -> ctrait.level * -1
          end

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

  def ke(character) do
    case Enum.find(character.character_traits, & &1.trait.name == "Geweihter") do
      nil ->
        %{ total: 0 }

      _ctrait ->
        ltrait_name =
          cond do
            Enum.find(character.character_traits, & &1.trait.name == "Tradition (Praioskirche))") -> :KL
            Enum.find(character.character_traits, & &1.trait.name == "Tradition (Rondrakirche)") -> :MU
            Enum.find(character.character_traits, & &1.trait.name == "Tradition (Boronkirche)") -> :MU
            Enum.find(character.character_traits, & &1.trait.name == "Tradition (Hesindekirche)") -> :KL
            Enum.find(character.character_traits, & &1.trait.name == "Tradition (Phexkirche)") -> :IN
            Enum.find(character.character_traits, & &1.trait.name == "Tradition (Perainekirche)") -> :IN
            true -> :KL
          end

        ltrait_value = Map.get(character, ltrait_name)

        bonus = Map.get(character, :ke_bonus)

        advantages =
          case Enum.find(character.character_traits, & &1.trait.name == "Hohe Karmalkraft") do
            nil -> 0
            ctrait -> ctrait.level
          end

        disadvantages =
          case Enum.find(character.character_traits, & &1.trait.name == "Niedrige Karmalkraft") do
            nil -> 0
            ctrait -> ctrait.level * -1
          end

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
