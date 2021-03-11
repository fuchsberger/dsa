defmodule DsaWeb.SkillView do
  use DsaWeb, :view

  alias Dsa.Data.Skill

  @header [
    body: [probe: "MU/GE/KK", pages: "188-194", title: "Körpertalente", short: "Körper"],
    social: [probe: "IN/CH/CH", pages: "194-198", title: "Gesellschaftstalente", short: "Gesellschaft"],
    nature: [probe: "MU/GE/KO", pages: "198-201", title: "Naturtalente", short: "Natur"],
    knowledge: [probe: "KL/KL/IN", pages: "201-206", title: "Wissenstalente", short: "Wissen"],
    crafting: [probe: "FF/FF/KO", pages: "206-213", title: "Handwerkstalente", short: "Handwerk"]
  ]

  def header_assigns(category), do: Keyword.get(@header, category)

  def be_options do
    [
      {gettext("Event."), nil},
      {gettext("Ja"), true},
      {gettext("Nein"), false}
    ]
  end

  def category_options, do: Enum.map(@header, fn {k, v} -> {Keyword.get(v, :short), k} end)

  def categories do
    [
      {gettext("Körpertalente"), gettext("Körper")},
      {gettext("Gesellschaftstalente"), gettext("Gesellschaft")},
      {gettext("Naturtalente"), gettext("Natur")},
      {gettext("Wissenstalente"), gettext("Wissen")},
      {gettext("Handwerkstalente"), gettext("Handwerk")}
    ]
  end

  def probe_defaults(form) do
    case input_value(form, :probe) do
      {t1, t2, t3} -> {t1, t2, t3}
      nil -> {0, 0, 0}
    end
  end
end
