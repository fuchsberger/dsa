defmodule DsaWeb.SkillController do
  use DsaWeb, :controller

  alias Dsa.Data

  def index(conn, _params) do
    conn
    |> assign(:skills, Data.list_skills())
    |> render("index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Data.change_skill(%Data.Skill{}))
    |> render("new.html")
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

  def edit(conn, %{"id" => id}) do
    skill = Data.get_skill!(id)

    conn
    |> assign(:changeset, Data.change_skill(skill))
    |> assign(:skill, skill)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "skill" => skill_params}) do
    skill = Data.get_skill!(id)

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
