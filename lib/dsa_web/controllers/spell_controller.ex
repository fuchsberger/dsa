defmodule DsaWeb.SpellController do
  use DsaWeb, :controller

  alias Dsa.Data

  def index(conn, _params) do
    conn
    |> assign(:spells, Data.list_spells())
    |> render("index.html")
  end
end
