defmodule DsaWeb.GameView do
  use DsaWeb, :view

  def action(changeset), do: if new?(changeset.data), do: :create, else: :update

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

  defp field_to_short(field) do
    field
    |> Atom.to_string()
    |> String.upcase(:ascii)
  end

  def filter_skills(form, tab) do
    Enum.filter(form.source.data.character_skills, & &1.skill.category == tab)
  end

  @doc """
  Checks whether a structure was newly build or loaded from database.
  """
  def new?(struct), do: Ecto.get_meta(struct, :state) == :built

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

  def skill_tab(name, active) do
    lnk = link name,
      to: "#",
      class: "nav-link p-1#{if name == active, do: " active"}",
      phx_click: "tab",
      phx_value_tab: name

    content_tag :li, lnk, class: "nav-item"
  end

  def tp(form) do
    case {input_value(form, :w2), input_value(form, :tp)} do
      {false, tp} -> "1W+#{tp}"
      {"false", tp} -> "1W+#{tp}"
      {true, tp} -> "2W+#{tp}"
    end
  end
end
