defmodule DsaWeb.SkillController do
  use DsaWeb, :controller

  alias Dsa.Accounts
  alias Dsa.Accounts.CharacterSkill
  alias Dsa.Data
  alias Dsa.Data.Skill

  @doc """
  Lists characters skills for trialing.
  """
  def index(conn, %{"character_id" => id}) do
    character = Accounts.get_user_character!(conn.assigns.current_user, id)
    changeset = Dsa.UI.change_skill_roll(%{})

    render(conn, "character_skills.html", character: character, changeset: changeset)
  end

  @doc """
  Lists Skills.
  """
  def index(conn, _params) do
    skills = Data.list_skills()
    render(conn, "index.html", skills: skills)
  end

  def new(conn, _params) do
    changeset = Data.change_skill(%Skill{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"skill" => skill_params}) do
    case Data.create_skill(skill_params) do
      {:ok, _skill} ->
        conn
        |> put_flash(:info, gettext("Skills updated successfully."))
        |> redirect(to: Routes.skill_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.warn inspect changeset
        render(conn, "new.html", changeset: changeset)
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

  def edit(conn, %{"id" => id}) do
    skill = Data.get_skill!(id)
    changeset = Data.change_skill(skill)
    render(conn, "edit.html", skill: skill, changeset: changeset)
  end

  def edit_skills(conn, %{"character_id" => id}) do
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

  def update(conn, %{"id" => id, "skill" => skill_params}) do
    skill = Data.get_skill!(id)
    Logger.warn "HEHEHEHE"
    case Data.update_skill(skill, skill_params) do
      {:ok, _skill} ->
        conn
        |> put_flash(:info, gettext("Skills updated successfully."))
        |> redirect(to: Routes.skill_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", skill: skill, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    skill = Data.get_skill!(id)
    {:ok, _skill} = Data.delete_skill(skill)

    conn
    |> put_flash(:info, gettext("Skills deleted successfully."))
    |> redirect(to: Routes.skill_path(conn, :index))
  end
end
