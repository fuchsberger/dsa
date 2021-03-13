defmodule DsaWeb.CharacterSkillController do
  @moduledoc """
  Handles all actions related to a user's character skills.
  """
  use DsaWeb, :controller

  alias Dsa.Accounts

  @doc """
  Lists characters skills for talent and trait rolls.
  """
  def index(conn, %{"character_id" => id}) do
    render conn, "character_skills.html",
      character: Accounts.get_user_character!(conn.assigns.current_user, id),
      changeset: Dsa.Event.change_skill_roll(%{}),
      trait_changeset: Dsa.Event.change_trait_roll(%{})
  end

  def edit(conn, %{"character_id" => id}) do
    character = Accounts.get_user_character!(conn.assigns.current_user, id)
    changeset = Accounts.change_character(character)
    render(conn, "character_edit_skills.html", character: character, changeset: changeset)
  end

  def update(conn, %{"character_id" => id, "character" => character_params}) do
    character = Accounts.get_user_character!(conn.assigns.current_user, id)

    Logger.warn inspect character

    case Accounts.update_character(character, character_params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character updated successfully.")
        |> redirect(to: Routes.character_skill_path(conn, :index, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.warn inspect changeset
        render(conn, "character_edit_skills.html", character: character, changeset: changeset)
    end
  end

  def add_all(conn, %{"character_id" => id}) do
    character = Accounts.get_user_character!(conn.assigns.current_user, id)

    case Accounts.add_skills(character) do
      {:ok, character} ->
        conn
        |> put_flash(:info, gettext("Skills updated successfully."))
        |> redirect(to: Routes.character_skill_path(conn, :edit_skills, character))

      {:error, changeset} ->
        Logger.warn inspect changeset
        render(conn, "character_edit_skills.html", character: character, changeset: changeset)
    end
  end

  def remove_all(conn, %{"character_id" => id}) do
    character = Accounts.get_user_character!(conn.assigns.current_user, id)

    case Accounts.remove_skills(character) do
      {:ok, character} ->
        conn
        |> put_flash(:info, gettext("Skills updated successfully."))
        |> redirect(to: Routes.character_skill_path(conn, :edit_skills, character))

      {:error, changeset} ->
        Logger.warn inspect changeset
        render(conn, "character_edit_skills.html", character: character, changeset: changeset)
    end
  end
end
