defmodule DsaWeb.CharacterSkillController do
  @moduledoc """
  Handles all actions related to a user's character skills.
  """
  use DsaWeb, :controller

  alias Dsa.{Characters, Event}

  action_fallback DsaWeb.ErrorController

  def action(conn, _) do
    with character <- Characters.get!(conn.assigns.current_user, conn.params["character_id"]) do
      conn = assign(conn, :character, character)
      apply(__MODULE__, action_name(conn), [conn, conn.params, character])
    end
  end

  def index(conn, _params, _character) do
    conn
    |> assign(:changeset, Event.change_skill_roll())
    |> render("index.html")
  end

  def edit_all(conn, _params, character) do
    conn
    |> assign(:character, character)
    |> assign(:changeset, Characters.change(character))
    |> render("edit.html")
  end

  def update_all(conn, %{"character" => params}, character) do
    case Characters.update(character, params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character updated successfully.")
        |> redirect(to: Routes.character_skill_path(conn, :index, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:character, character)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def add_all(conn, _params, character) do
    case Characters.add_skills(character) do
      {:ok, character} ->
        conn
        |> put_flash(:info, gettext("Skills updated successfully."))
        |> redirect(to: Routes.character_skill_path(conn, :edit_all, character))

      {:error, changeset} ->
        conn
        |> assign(:character, character)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def remove_all(conn, _params, character) do
    case Characters.remove_skills(character) do
      {:ok, character} ->
        conn
        |> put_flash(:info, gettext("Skills updated successfully."))
        |> redirect(to: Routes.character_skill_path(conn, :edit_all, character))

      {:error, changeset} ->
        conn
        |> assign(:character, character)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end
end
