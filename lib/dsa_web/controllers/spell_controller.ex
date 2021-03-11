defmodule DsaWeb.SpellController do
  use DsaWeb, :controller

  alias Dsa.{Accounts, Data, Event}

  @doc """
  Lists characters spells for trialing.
  """
  def index(conn, %{"character_id" => id}) do
    render conn, "character_spells.html",
      character: Accounts.get_user_character!(conn.assigns.current_user, id),
      changeset: Dsa.Event.change_spell_roll(%{}),
      trait_changeset: Dsa.Event.change_trait_roll(%{})
  end

  @doc """
  Lists Skills.
  """
  def index(conn, _params) do
    spells = Data.list_spells()
    render(conn, "index.html", spells: spells)
  end
end
