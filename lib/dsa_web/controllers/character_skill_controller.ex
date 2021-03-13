defmodule DsaWeb.CharacterSkillController do
  @moduledoc """
  Handles all actions related to a user's character skills.
  """
  use DsaWeb, :controller

  alias Dsa.{Characters, Event}

  action_fallback DsaWeb.ErrorController
  plug :assign_character

  def index(conn, _params, character) do
    conn
    |> assign(:character, character)
    |> assign(:changeset, Event.change_skill_roll(%{}))
    |> assign(:trait_changeset, Event.change_trait_roll(%{}))
    |> render("index.html")
  end

  def edit(conn, _params, character) do
    conn
    |> assign(:character, character)
    |> assign(:changeset, Characters.change(character))
    |> render("character_edit_skills.html")
  end

  def update(conn, %{"character" => params}, character) do
    case Characters.update(character, params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character updated successfully.")
        |> redirect(to: Routes.character_skill_path(conn, :index, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:character, character)
        |> assign(:changeset, changeset)
        |> render("character_edit_skills.html")
    end
  end

  def add_all(conn, _params, character) do
    case Characters.add_skills(character) do
      {:ok, character} ->
        conn
        |> put_flash(:info, gettext("Skills updated successfully."))
        |> redirect(to: Routes.character_skill_path(conn, :edit_skills, character))

      {:error, changeset} ->
        conn
        |> assign(:character, character)
        |> assign(:changeset, changeset)
        |> render("character_edit_skills.html")
    end
  end

  def remove_all(conn, _params, character) do
    case Characters.remove_skills(character) do
      {:ok, character} ->
        conn
        |> put_flash(:info, gettext("Skills updated successfully."))
        |> redirect(to: Routes.character_skill_path(conn, :edit_skills, character))

      {:error, changeset} ->
        conn
        |> assign(:character, character)
        |> assign(:changeset, changeset)
        |> render("character_edit_skills.html")
    end
  end

  defp assign_character(conn, _opts) do
    with {:ok, c} <- Characters.get!(conn.assigns.current_user, conn.params["character_id"]) do
      assign(conn, :character, c)
    end
  end
end
