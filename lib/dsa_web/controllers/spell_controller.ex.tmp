defmodule DsaWeb.SpellController do
  use DsaWeb, :controller

  alias Dsa.Data

  def index(conn, _params) do
    entries = Data.list_spells()

    conn
    |> assign(:rituals, Enum.filter(entries, & &1.ritual == true))
    |> assign(:spells, Enum.filter(entries, & &1.ritual == false))
    |> render("index.html")
  end
end
