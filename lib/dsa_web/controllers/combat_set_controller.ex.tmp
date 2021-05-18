defmodule DsaWeb.CombatSetController do
  use DsaWeb, :controller

  alias Dsa.Characters
  alias Dsa.Characters.CombatSet

  action_fallback DsaWeb.ErrorController

  def action(conn, _) do
    with {:ok, character} <- Characters.fetch(conn.params["character_id"]),
      :ok <- authorized(conn.assigns.current_user, character)
    do
      conn = assign(conn, :character, character)
      apply(__MODULE__, action_name(conn), [conn, conn.params, character])
    end
  end

  # Only permit actions if admin or changeset is owned.
  defp authorized(user, character) do
    if user.admin || character.user_id == user.id, do: :ok, else: {:error, :forbidden}
  end

  def index(conn, _params, character) do
    conn
    |> assign(:combat_sets, Characters.list_combat_sets(character))
    |> render("index.html")
  end

  def new(conn, _params, _character) do
    conn
    |> assign(:changeset, Characters.change_combat_set(%CombatSet{}))
    |> render("new.html")
  end

  def create(conn, %{"combat_set" => combat_set_params}, character) do
    case Characters.create_combat_set(character, combat_set_params) do
      {:ok, _combat_set} ->
        conn
        |> put_flash(:info, gettext("Combat set created successfully."))
        |> redirect(to: Routes.character_combat_set_path(conn, :index, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def show(conn, %{"id" => id}, character) do
    conn
    |> assign(:combat_set, Characters.get_combat_set!(character, id))
    |> render("show.html")
  end

  def edit(conn, %{"id" => id}, character) do
    combat_set = Characters.get_combat_set!(character, id)

    conn
    |> assign(:changeset, Characters.change_combat_set(combat_set))
    |> assign(:combat_set, combat_set)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "combat_set" => combat_set_params}, character) do
    combat_set = Characters.get_combat_set!(character, id)

    case Characters.update_combat_set(combat_set, combat_set_params) do
      {:ok, _combat_set} ->
        conn
        |> put_flash(:info, gettext("Combat set updated successfully."))
        |> redirect(to: Routes.character_combat_set_path(conn, :index, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}, character) do
    combat_set = Characters.get_combat_set!(character, id)
    {:ok, _combat_set} = Characters.delete_combat_set(combat_set)

    conn
    |> put_flash(:info, gettext("Combat set deleted successfully."))
    |> redirect(to: Routes.character_combat_set_path(conn, :index, character))
  end
end
