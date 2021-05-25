defmodule DsaWeb.SkillController do
  use DsaWeb, :controller

  alias Dsa.Data

  def index(conn, _params) do
    skills = Data.list_skills()

    conn
    |> assign(:body_skills, Enum.filter(skills, & &1.category == :body))
    |> assign(:social_skills, Enum.filter(skills, & &1.category == :social))
    |> assign(:nature_skills, Enum.filter(skills, & &1.category == :nature))
    |> assign(:knowledge_skills, Enum.filter(skills, & &1.category == :knowledge))
    |> assign(:crafting_skills, Enum.filter(skills, & &1.category == :crafting))
    |> render("index.html")
  end
end
