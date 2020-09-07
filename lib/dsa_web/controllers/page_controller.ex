defmodule DsaWeb.PageController do
  use DsaWeb, :controller

  require Logger
  alias Dsa.{Accounts, Lore}

  def create_character(conn, _) do
    case Accounts.create_character(conn.assigns.current_user, %{species_id: 1}) do
      {:ok, %{id: id}} ->
        redirect(conn, to: Routes.character_path(conn, :edit, id))

      {:error, changeset} ->
        Logger.error("Error creating character: #{inspect(changeset.errors)}")
        redirect(conn, to: Routes.character_path(conn, :index))
    end
  end

  def seed(conn, _) do
    if conn.assigns.current_user.admin, do: Lore.seed()
    redirect(conn, to: Routes.manage_path(conn, :combat_skills))
  end
end
