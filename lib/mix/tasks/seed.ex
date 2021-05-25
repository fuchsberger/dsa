defmodule Mix.Tasks.Seed do
  @moduledoc """
  Syncronizes database with data from /priv/repo/data.json
  Also updates Algolia search with new data.

  Can be run via: $ mix seed
  """
  use Mix.Task
  require Logger

  alias Dsa.Data

  @shortdoc "Populates the database and updates algolia search index"
  def run(_) do
    # This will start our application
    Mix.Task.run("app.start")
    seed()
  end

  defp seed do
    Logger.info("Reading data.json file")
    data = read_file("priv/repo/data.json")

    # Handle skills
    skills = Data.list_skills()
    skill_ids = Enum.map(skills, & &1.id)

    Enum.each(data["skills"], fn skill_params ->
      if Enum.member?(skill_ids, skill_params["id"]) do
        skill = Enum.find(skills, & &1.id == skill_params["id"])
        case Data.update_skill(skill, skill_params) do
          {:ok, skill} ->
            Logger.debug("Updated Skill #{skill.name}")

          {:error, changeset} ->
            Logger.error("Error when updating skill:")
            Logger.error(inspect(changeset.errors))
        end
      else
        case Data.create_skill(skill_params) do
          {:ok, skill} ->
            Logger.debug("Added Skill #{skill.name}")

          {:error, changeset} ->
            Logger.error("Error when adding skill:")
            Logger.error(inspect(changeset.errors))
        end
      end
    end)

    Logger.info("Finished database syncronization")
  end

  defp read_file(filename) do
    filename
    |> File.read!()
    |> Jason.decode!()
  end
end
