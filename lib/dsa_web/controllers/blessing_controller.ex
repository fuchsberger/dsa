defmodule DsaWeb.BlessingController do
  use DsaWeb, :controller

  alias Dsa.Data

  def index(conn, _params) do
    entries = Data.list_blessings()

    conn
    |> assign(:rituals, Enum.filter(entries, & &1.ritual == true))
    |> assign(:blessings, Enum.filter(entries, & &1.ritual == false))
    |> render("index.html")
  end
end
