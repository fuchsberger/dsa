defmodule DsaWeb.SkillView do
  use DsaWeb, :view

  alias Dsa.Data.Skill

  def categories do
    [
      {gettext("Körpertalente"), gettext("Körper")},
      {gettext("Gesellschaftstalente"), gettext("Gesellschaft")},
      {gettext("Naturtalente"), gettext("Natur")},
      {gettext("Wissenstalente"), gettext("Wissen")},
      {gettext("Handwerkstalente"), gettext("Handwerk")}
    ]
  end

  def header_row_assigns(character, category) do
    {title, _short} = Enum.at(categories, category - 1)

    case category do
      1 -> [traits: "MU/GE/KK", pages: "188-194" ]
      2 -> [traits: "IN/CH/CH", pages: "194-198" ]
      3 -> [traits: "MU/GE/KO", pages: "198-201" ]
      4 -> [traits: "KL/KL/IN", pages: "201-206" ]
      5 -> [traits: "FF/FF/KO", pages: "206-213" ]
    end
    |> Keyword.put(:ap, ap(character, :skills, category))
    |> Keyword.put(:title, title)
  end

  def row_assigns(conn, character, skill_id, form \\ nil) do
    field = Skill.field(skill_id)
    value = Map.get(character, field)

    [
      id: skill_id,
      be: be(Skill.be(skill_id)),
      name: Skill.name(skill_id),
      probe: Skill.probe(skill_id),
      sf: Skill.sf(skill_id),
      show_minus: (if value == 29, do: "hidden"),
      show_plus: (if value == 0, do: "hidden"),
      skill_value: value,
      f: form,
      field: field,
      path: Routes.character_path(conn, :skill_roll, character, skill_id)
    ]
  end
end
