defmodule DsaWeb.SkillController do
  use DsaWeb, :controller

  alias Dsa.Data

  def index(conn, _params) do
    skills = Data.list_skills()

    conn
    |> assign(:physical_skills, Enum.filter(skills, & &1.category == :physical))
    |> assign(:social_skills, Enum.filter(skills, & &1.category == :social))
    |> assign(:nature_skills, Enum.filter(skills, & &1.category == :nature))
    |> assign(:knowledge_skills, Enum.filter(skills, & &1.category == :knowledge))
    |> assign(:crafting_skills, Enum.filter(skills, & &1.category == :crafting))
    |> render("index.html")
  end

  def show(conn, %{"slug" => slug}) do
    case Data.get_by_slug(:skills, slug) do
      nil ->
        render(conn, DsaWeb.ErrorView, "404.html")
      skill ->
        render(conn, "show.html", skill: skill)
    end
  end
end
