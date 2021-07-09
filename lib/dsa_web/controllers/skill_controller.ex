defmodule DsaWeb.SkillController do
  use DsaWeb, :controller

  alias Dsa.{Data, Game}

  action_fallback DsaWeb.ErrorController

  defp action(conn, _) do
    character = conn.assigns.current_user && Map.get(conn.assigns.current_user, :active_character)

    args = [conn, conn.params, character]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, character) do
    skills = Data.list_skills()

    changeset =
      case character do
        nil -> nil
        character -> Game.change_character(character, %{})
      end

    conn
    |> assign(:changeset, changeset)
    |> assign(:physical_skills, Enum.filter(skills, & &1.category == :physical))
    |> assign(:social_skills, Enum.filter(skills, & &1.category == :social))
    |> assign(:nature_skills, Enum.filter(skills, & &1.category == :nature))
    |> assign(:knowledge_skills, Enum.filter(skills, & &1.category == :knowledge))
    |> assign(:crafting_skills, Enum.filter(skills, & &1.category == :crafting))
    |> render("index.html")
  end

  def show(conn, %{"slug" => slug}, _character) do
    case Data.get_by_slug(:skills, slug) do
      nil ->
        render(conn, DsaWeb.ErrorView, "404.html")
      skill ->
        render(conn, "show.html", skill: skill)
    end
  end
end
