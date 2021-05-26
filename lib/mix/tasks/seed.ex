defmodule Mix.Tasks.Seed do
  @moduledoc """
  Syncronizes database with data from /priv/repo/data.json

  Can be run via: $ mix seed
  """
  use Mix.Task
  require Logger

  alias Dsa.Data
  alias Dsa.Data.Skill

  @shortdoc "Populates the database with DSA data."
  def run(_) do
    # This will start our application
    Mix.Task.run("app.start")
    seed()
  end

  defp seed do
    Logger.info("Reading data.json file")
    data = read_file("priv/repo/data.json")

    # Handle skills
    Logger.info("Saving Skills...")

    skills = Data.list_skills()
    Enum.each(data["skills"], fn skill_params ->
      id = skill_params["id"]
      skill = Enum.find(skills, %Skill{id: id}, & &1.id == id)

      case Data.save_skill(skill, skill_params) do
        {:ok, skill} ->
          Logger.debug("Saved Skill #{skill.name}")

        {:error, changeset} ->
          Logger.error("Error when saving skill:")
          Logger.error(inspect(changeset.errors))
      end
    end)

    Logger.info("Finished seeding database...")

    # Enum.each(data["skills"], fn skill_params ->
    #   if Enum.member?(skill_ids, skill_params["id"]) do
    #     skill = Enum.find(skills, & &1.id == skill_params["id"])
    #     case Data.update_skill(skill, skill_params) do
    #       {:ok, skill} ->
    #         Logger.debug("Updated Skill #{skill.name}")

    #       {:error, changeset} ->
    #         Logger.error("Error when updating skill:")
    #         Logger.error(inspect(changeset.errors))
    #     end
    #   else
    #     case Data.create_skill(skill_params) do
    #       {:ok, skill} ->
    #         Logger.debug("Added Skill #{skill.name}")

    #       {:error, changeset} ->
    #         Logger.error("Error when adding skill:")
    #         Logger.error(inspect(changeset.errors))
    #     end
    #   end
    # end)
  end

  defp algoria_index, do: "#{Application.get_env(:dsa, :environment)}_records"

  defp read_file(filename) do
    filename
    |> File.read!()
    |> Jason.decode!()
  end
end
