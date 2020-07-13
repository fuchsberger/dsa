defmodule DsaWeb.DsaHelpers do
  @moduledoc """
  Conveniences specific for the app
  """
  use Phoenix.HTML
  import Phoenix.HTML.Form, only: [input_value: 2]
  import Dsa.Game.Character, only: [talents: 1]


  @doc """
  Attacke Wert für ein Kampftalent.
  """
  def at(c, talent) do
    trait = if Enum.any?(talents("Nahkampf"), & &1 == talent), do: :mu, else: :ff
    Map.get(c, talent) + floor((Map.get(c, trait) - 8) / 3)
  end

  def pa(character, talent) do
    st = Map.get(character, talent)
    %{ge: ge, kk: kk} = character
    bon =
      cond do
        Enum.member?([:cc_dolche, :cc_faecher, :cc_fechtwaffen], talent) -> ge
        Enum.member?([:cc_raufen, :cc_schwerter, :cc_stangenwaffen], talent) -> max(ge, kk)
        Enum.member?([:cc_hiebwaffen, :cc_lanzen, :cc_schilde, :cc_zweihandhiebwaffen, :cc_zweihandschwerter], talent) -> kk
        true -> nil
      end
    if is_nil(bon), do: nil, else: round(st/2) + floor((bon - 8) / 3)
  end

  def be_text(be) do
    case be do
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


  def get_talent_details(form) do
    form
    |> input_value(:talent)
    |> String.to_atom()
    |> talent_details()
  end

  def get_trait_name(form) do
    form
    |> input_value(:trait)
    |> String.to_atom()
    |> name()
  end

  def talent_details(short) do
    case short do
      # name, e1, e2, e3, be

      # Körpertalente
      :ta_fliegen -> {"Fliegen", :mu, :in, :ge, true}
      :ta_gaukeleien -> {"Gaukeleien", :mu, :ch, :ff, true}
      :ta_klettern -> {"Klettern", :mu, :ge, :kk, true}
      :ta_koerperbeherrschung -> {"Körperbeherrschung", :ge, :ge, :ko, true}
      :ta_kraftakt -> {"Kraftakt", :ko, :kk, :kk, true}
      :ta_reiten -> {"Reiten", :ch, :ge, :kk, true}
      :ta_schwimmen -> {"Schwimmen", :ge, :ko, :kk, true}
      :ta_selbstbeherrschung -> {"Selbstbeherrschung", :mu, :mu, :ko, false}
      :ta_singen -> {"Singen", :kl, :ch, :ko, nil}
      :ta_sinnesschaerfe -> {"Sinnesschärfe", :kl, :in, :in, nil}
      :ta_tanzen -> {"Tanzen", :kl, :ch, :ge, true}
      :ta_taschendiebstahl -> {"Taschendiebstahl", :mu, :ff, :ge, true}
      :ta_verbergen -> {"Verbergen", :mu, :in, :ge, true}
      :ta_zechen -> {"Zechen", :kl, :ko, :kk, false}

      # Gesellschaftstalente
      :ta_bekehren -> {"Bekehren / Überzeugen", :mu, :kl, :ch, false}
      :ta_betoeren -> {"Betören", :mu, :ch, :ch, nil}
      :ta_einschuechtern -> {"Einschüchtern", :mu, :in, :ch, false}
      :ta_etikette -> {"Etikette", :kl, :in, :ch, nil}
      :ta_gassenwissen -> {"Gassenwissen", :kl, :in, :ch, nil}
      :ta_menschenkenntnis -> {"Menschenkenntnis", :kl, :in, :ch, false}
      :ta_ueberreden -> {"Überreden", :mu, :in, :ch, false}
      :ta_verkleiden -> {"Verkleiden", :in, :ch, :ge, nil}
      :ta_willenskraft -> {"Willenskraft", :mu, :in, :ch, false}

      # Naturtalente
      :ta_faehrtensuchen -> {"Fährtensuchen", :mu, :in, :ch, true}
      :ta_fesseln -> {"Fesseln", :kl, :ff, :kk, nil}
      :ta_fischen -> {"Fischen & Angeln", :ff, :ge, :ko, nil}
      :ta_orientierung -> {"Orientierung", :kl, :in, :in, false}
      :ta_pflanzenkunde -> {"Pflanzenkunde", :kl, :ff, :ko, nil}
      :ta_tierkunde -> {"Tierkunde", :mu, :mu, :ch, true}
      :ta_wildnisleben -> {"Wildnisleben", :mu, :ge, :ko, true}

      # Wissenstalente
      :ta_brettspiel -> {"Brett- & Glücksspiel", :kl, :in, :ch, false}
      :ta_geographie -> {"Geographie", :kl, :in, :ch, false}
      :ta_geschichtswissen -> {"Geschichtswissen", :kl, :in, :ch, false}
      :ta_goetter -> {"Götter & Kulte", :kl, :in, :ch, false}
      :ta_kriegskunst -> {"Kriegskunst", :mu, :kl, :in, false}
      :ta_magiekunde -> {"Magiekunde", :kl, :in, :ch, false}
      :ta_mechanik -> {"Mechanik", :kl, :kl, :ff, false}
      :ta_rechnen -> {"Rechnen", :kl, :in, :ch, false}
      :ta_rechtskunde -> {"Rechtskunde", :kl, :in, :ch, false}
      :ta_sagen -> {"Sagen & Legenden", :kl, :in, :ch, false}
      :ta_sphaerenkunde -> {"Sphärenkunde", :kl, :in, :ch, false}
      :ta_sternkunde -> {"Sternkunde", :kl, :in, :ch, false}

      # Handwerkstalente
      :ta_alchimie -> {"Alchimie", :mu, :kl, :ff, true}
      :ta_boote -> {"Boote & Schiffe", :ff, :ge, :kk, true}
      :ta_fahrzeuge -> {"Fahrzeuge", :ch, :ff, :ko, true}
      :ta_handel -> {"Handel", :kl, :in, :ch, false}
      :ta_gift -> {"Heilkunde Gift", :mu, :kl, :in, true}
      :ta_krankheiten -> {"Heilkunde Krankheiten", :mu, :in, :ko, true}
      :ta_seele -> {"Heilkunde Seele", :in, :ch, :ko, true}
      :ta_wunden -> {"Heilkunde Wunden", :kl, :ff, :ff, true}
      :ta_holz -> {"Holzbearbeitung", :ff, :ge, :kk, true}
      :ta_lebensmittel -> {"Lebensmittelbearbeitung", :in, :ff, :ff, true}
      :ta_leder -> {"Lederbearbeitung", :ff, :ge, :ko, true}
      :ta_malen -> {"Malen & Zeichnen", :in, :ff, :ff, true}
      :ta_metall -> {"Metallbearbeitung", :ff, :ko, :kk, true}
      :ta_musizieren -> {"Musizieren", :ch, :ff, :ko, true}
      :ta_schloesser -> {"Schlösserknacken", :in, :ff, :ff, true}
      :ta_stein -> {"Steinbearbeitung", :ff, :ff, :kk, true}
      :ta_stoff -> {"Stoffbearbeitung", :kl, :ff, :ff, true}
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

  def trait_options do
    Enum.map(talents("Eigenschaften"), & {String.upcase(Atom.to_string(&1)), &1})
  end

  def badge_quality(_res, true), do: content_tag :span, "X", class: "badge bg-success"

  def badge_quality(res, critical) when res >= 0 and critical != false do
    content_tag :span, quality(res), class: "badge bg-success"
  end

  def badge_quality(_res, _critical), do: ""
end
