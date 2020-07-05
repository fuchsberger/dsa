defmodule DsaWeb.CharacterView do
  use DsaWeb, :view

  alias Ecto.Changeset

  @eigenschaften [:mu, :kl, :in, :ch, :ff, :ge, :ko, :kk]

  def sum_eigenschaften(changeset),
    do: Enum.reduce(@eigenschaften, 0, fn x, acc -> acc + Changeset.get_field(changeset, x) end)

  def cost_eigenschaften(changeset) do
    Enum.reduce(@eigenschaften, 0, fn x, acc ->
      changeset
      |> Changeset.get_field(x)
      |> cost_talent()
      |> Kernel.+(acc)
    end)
  end

  def allowed_eigenschaften(changeset) do
    ap = Changeset.get_field(changeset, :ap)
    cond do
      ap < 1000 -> 95
      ap < 1100 -> 98
      ap < 1200 -> 100
      ap < 1400 -> 102
      ap < 1700 -> 105
      ap < 2100 -> 109
      ap >= 2100 -> 114
    end
  end

  defp cost_talent(level) do
    case level do
      8 -> 0
      9 -> 15
      10 -> 30
      11 -> 45
      12 -> 60
      13 -> 75
      14 -> 90
      15 -> 120
      16 -> 165
      17 -> 225
      18 -> 300
      _ -> 300 + (level - 18) * 90
    end
  end

  def erfahrungsstufe(changeset) do
    ap = Changeset.get_field(changeset, :ap)
    cond do
      ap < 1000 -> "Unerfahren"
      ap < 1100 -> "Durchschnittlich"
      ap < 1200 -> "Erfahren"
      ap < 1400 -> "Kompetent"
      ap < 1700 -> "Meisterlich"
      ap < 2100 -> "Brillant"
      ap >= 2100 -> "Legendär"
    end
  end

  def tab(title, active_tab) do
    content_tag :li,
      link(title,
        to: "##{title}",
        id: "tab-#{title}",
        area_controls: title,
        area_selected: title == active_tab,
        class: "nav-link#{if title == active_tab, do: " active"}",
        phx_click: "tab",
        phx_value_id: title,
        role: "tab"
      ),
      class: "nav-item",
      role: "presentation"
  end

  def tab_panel(title, active, block) do
    content_tag(:div, [
      area_labelledby: "tab-#{title}",
      class: "tab-pane fade#{if title == active, do: "show active"}",
      role: "tabpanel"
    ], block)
  end
end
