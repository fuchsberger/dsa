defmodule DsaWeb.DsaHelpers do
  @moduledoc """
  Conveniences specific for the app
  """
  use Phoenix.HTML

  @base_values ~w(mu kl in ch ff ge ko kk)a

  def traits(probe) do
    probe
    |> String.downcase()
    |> String.split("/")
    |> Enum.map(& String.to_atom(&1))
  end

  def trait_index(trait) do
    Enum.find_index(@base_values, trait)
  end

  # def base_value_indexes(probe) do
  #   [b1, b2, b3] =
  #     probe
  #     |> String.downcase()
  #     |> String.split("/")
  #     |> Enum.map(& String.to_atom(&1))

  #   [
  #     Enum.find_index(base_values(), & &1 == b1),
  #     Enum.find_index(base_values(), & &1 == b2),
  #     Enum.find_index(base_values(), & &1 == b3)
  #   ]
  # end

  def be(be?) do
    case be? do
      true -> "Ja"
      false -> "Nein"
      nil -> "Evtl"
    end
  end

  def short_trait(trait), do: trait |> Atom.to_string() |> String.upcase(:ascii)

  def name(talent) do
    case talent do
      :mu -> "Mut"
      :kl -> "Klugheit"
      :in -> "Intuition"
      :ch -> "Charisma"
      :ff -> "Fingerfertigkeit"
      :ge -> "Gewandheit"
      :ko -> "Konstitution"
      :kk -> "Körperkraft"
      :cc_dolche -> "Dolche"
      :cc_faecher -> "Fächer"
      :cc_fechtwaffen -> "Fechtwaffen"
      :cc_hiebwaffen -> "Hiebwaffen"
      :cc_kettenwaffen -> "Kettenwaffen"
      :cc_lanzen -> "Lanzen"
      :cc_peitschen -> "Peitschen"
      :cc_raufen -> "Raufen"
      :cc_schilde -> "Schilde"
      :cc_schwerter -> "Schwerter"
      :cc_spiesswaffen -> "Spießwaffen"
      :cc_stangenwaffen -> "Stangenwaffen"
      :cc_zweihandhiebwaffen -> "Zweihandhiebwaffen"
      :cc_zweihandschwerter -> "Zweihandschwerter"
      :rc_armbrueste -> "Armbrüste"
      :rc_blasrohre -> "Blasrohre"
      :rc_boegen -> "Bögen"
      :rc_diskusse -> "Diskusse"
      :rc_feuerspeien -> "Feuerspeien"
      :rc_schleudern -> "Schleudern"
      :rc_wurfwaffen -> "Wurfwaffen"
      _ -> "no translation..."
    end
  end

  def quality(result) do
    cond do
      result >= 16 -> 6
      result >= 13 -> 5
      result >= 10 -> 4
      result >= 7 -> 3
      result >= 4 -> 2
      true -> 1
    end
  end

  def category_name(category) do
    case category do
      1 -> "Körper"
      2 -> "Gesellschaft"
      3 -> "Natur"
      4 -> "Wissen"
      5 -> "Handwerk"
      6 -> "Zauber"
      7 -> "Liturgie"
    end
  end

  def roman(number) do
    case number do
      1 -> "I"
      2 -> "II"
      3 -> "III"
      4 -> "IV"
      5 -> "V"
      6 -> "VI"
      7 -> "VII"
      8 -> "VIII"
      9 -> "IX"
      10 -> "X"
    end
  end

  def talent_group(category) do
    case category do
      nil -> "Kampftechniken"
      1 -> "Körpertalente"
      2 -> "Gesellschaftstalente"
      3 -> "Naturtalente"
      4 -> "Wissenstalente"
      5 -> "Handwerkstalente"
      6 -> "Zauber"
      7 -> "Liturgien"
    end
  end

  def ap_cost(level, sf, activate? \\ false)
  def ap_cost(0, _sf, false), do: 0
  def ap_cost(level, sf, false), do: Enum.map(1..level, & ap_level(&1, sf)) |> Enum.sum()
  def ap_cost(level, sf, true), do: Enum.map(0..level, & ap_level(&1, sf)) |> Enum.sum()

  def ap_level(level, sf) do
    case sf do
      "A" -> if level < 13, do: 1, else: level - 11
      "B" -> if level < 13, do: 2, else: level * 2 - 22
      "C" -> if level < 13, do: 3, else: level * 3 - 33
      "D" -> if level < 13, do: 4, else: level * 4 - 44
      "E" -> if level == 0, do: 0, else: (if level < 15, do: 15, else: (level - 13) * 15)
    end
  end
end
