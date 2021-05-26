defmodule Mix.Tasks.Algolia do
  @moduledoc """
  Syncronizes database with algolia search engine index.

  Can be run via: $ mix algolia
  """
  use Mix.Task

  alias Dsa.Data
  alias Dsa.Data.Skill

  require Logger

  @shortdoc "Syncronizes algolia search index with app data"
  def run(_) do
    # This will start our application
    Mix.Task.run("app.start")
    sync()
  end

  defp sync do

    Logger.info("Updating skills in algolia index...")

    prepared_skills = Data.list_skills() |> Enum.map(& Skill.format_algolia(&1))
    Algolia.save_objects(algoria_index(), prepared_skills)

    Logger.info("Finished database syncronization")
  end

  defp algoria_index, do: "#{Application.get_env(:dsa, :environment)}_records"
end
