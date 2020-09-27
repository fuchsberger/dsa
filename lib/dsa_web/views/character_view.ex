defmodule DsaWeb.CharacterView do
  use DsaWeb, :view

  # import DSA.Lists
  import DsaWeb.CharacterHelpers

  alias Dsa.Data.{
    Armor,
    Blessing,
    CombatTrait,
    FateTrait,
    FWeapon,
    KarmalTrait,
    Language,
    MagicTrait,
    MWeapon,
    Script,
    SpellTrick,
    StaffSpell
  }

  def talent_tab(name, category, active_category) do
    active = category == active_category

    lnk = link name,
      to: "#",
      area_current: active,
      class: "nav-link px-2 py-1#{if active, do: " active"}",
      phx_click: "select",
      phx_value_category: category

    content_tag :li, lnk, class: "nav-item"
  end

  def field(form, field, _tooltip \\ nil) do
    ~E"""
    <div class='col-sm-3'>
      <div class="input-group input-group-sm mb-2">
        <%= label form, field, field_to_short(field),
          class: "input-group-text font-weight-bold" %>
        <%= number_input form, field %>
      </div>
    </div>
    """
  end

  def combat_stats(form, skill_form) do
    category = skill_form.data.skill.category
    {trait, value} = leiteigenschaft(form, skill_form.data.skill)
    level = input_value(skill_form, :level)

    case category do
      "Nahkampf" ->
        mu = input_value(form, :mu)
        {trait, level + floor((mu-8)/3), round(level/2) + floor((value-8)/3)}
      "Fernkampf" ->
        ff = input_value(form, :ff)
        {trait, level + floor((ff-8)/3), nil}
    end
  end

  defp leiteigenschaft(form, %{e1: e1, e2: e2}) do
    a = e1 |> String.downcase() |> String.to_atom()
    b = e2 && e2 |> String.downcase() |> String.to_atom()

    case {a, b} do
      {a, nil} ->
        {e1, input_value(form, a)}

      {a, b} ->
        a = input_value(form, a)
        b = input_value(form, b)
        if a >= b, do: {e1, a}, else: {e2, b}
    end
  end

  defp field_to_short(field) do
    field
    |> Atom.to_string()
    |> String.upcase(:ascii)
  end

  def form_group(form, group) do
    form
    |> inputs_for(:character_skills)
    |> Enum.filter(& &1.data.skill.category == group)
  end

  def form_heading(:create), do: "Held erstellen"
  def form_heading(:update), do: "Held bearbeiten"

  def path(conn, :create), do: Routes.character_path(conn, :create)
  def path(conn, :update), do: Routes.character_path(conn, :update, conn.assigns.changeset.data)

  def range(form) do
    case input_value(form, :rw) do
      0 -> "K"
      "0" -> "K"
      1 -> "M"
      "1" -> "M"
      2 -> "L"
      "2" -> "L"
    end
  end

  def tab(name) do
    active = name == "Kampf"
    lnk = link String.capitalize(name),
      area_controls: name,
      area_selected: active,
      class: "nav-link p-1#{if active, do: " active"}",
      data_toggle: "tab",
      id: "#{name}-tab",
      to: "##{name}",
      role: "tab"

    content_tag :li, lnk, class: "nav-item", role: "presentation"
  end

  def tp(form) do
    case {input_value(form, :w2), input_value(form, :tp)} do
      {false, tp} -> "1W+#{tp}"
      {"false", tp} -> "1W+#{tp}"
      {true, tp} -> "2W+#{tp}"
    end
  end

  def list_options(character, options) do
    filter_ids = Enum.map(character.character_skills, & &1.skill_id)
    Enum.reject(options, fn {_name, id} -> Enum.member?(filter_ids, id) end)
  end
end
