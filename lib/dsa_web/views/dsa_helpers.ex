defmodule DsaWeb.DsaHelpers do
  @moduledoc """
  Conveniences specific for the app
  """
  use Phoenix.HTML

  @doc """
  Attacke Wert für ein Kampftalent.
  """
  def at(_c, _talent) do
    # trait = if Enum.any?(talents("Nahkampf"), & &1 == talent), do: :mu, else: :ff
    # Map.get(c, talent) + floor((Map.get(c, trait) - 8) / 3)
    ""
  end

  def pa(_c, _talent) do
    # st = Map.get(character, talent)
    # %{ge: ge, kk: kk} = character
    # bon =
    #   cond do
    #     Enum.member?([:cc_dolche, :cc_faecher, :cc_fechtwaffen], talent) -> ge
    #     Enum.member?([:cc_raufen, :cc_schwerter, :cc_stangenwaffen], talent) -> max(ge, kk)
    #     Enum.member?([:cc_hiebwaffen, :cc_lanzen, :cc_schilde, :cc_zweihandhiebwaffen, :cc_zweihandschwerter], talent) -> kk
    #     true -> nil
    #   end
    # if is_nil(bon), do: nil, else: round(st/2) + floor((bon - 8) / 3)
    ""
  end

  def be(be?) do
    case be? do
      true -> "Ja"
      false -> "Nein"
      nil -> "Event."
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
end
