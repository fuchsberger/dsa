defmodule DsaWeb.SpellController do
  use DsaWeb, :controller

  alias Dsa.{Accounts, Data, Event}

  def index(conn, %{"character_id" => id}) do
    render conn, "character_spells.html",
      character: Accounts.get_user_character!(conn.assigns.current_user, id),
      changeset: Dsa.Event.change_spell_roll(%{}),
      trait_changeset: Dsa.Event.change_trait_roll(%{})
  end

  def index(conn, _params) do
    conn
    |> assign(:spells, Data.list_spells())
    |> render("index.html")
  end
end
