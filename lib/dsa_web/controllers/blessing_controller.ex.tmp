defmodule DsaWeb.BlessingController do
  use DsaWeb, :controller

  alias Dsa.Data

  def index(conn, _params) do
    entries = Data.list_blessings()

    conn
    |> assign(:ceremony, Enum.filter(entries, & &1.ceremony == true))
    |> assign(:blessings, Enum.filter(entries, & &1.ceremony == false))
    |> render("index.html")
  end
end
