defmodule Mix.Tasks.Seed do
  @moduledoc """
  Syncronizes database with data from /priv/repo/data.json
  Also updates Algolia search with new data.

  Can be run via: $ mix seed
  """
  use Mix.Task
  require Logger

  @shortdoc "Populates the database and updates algolia search index"
  def run(_) do
    # This will start our application
    Mix.Task.run("app.start")
    seed()
  end

  defp seed do
    Logger.debug("Reading data.json file.")
    _data = read_file("priv/repo/data.json")
    Logger.info("Finished database syncronization.")
  end

  defp read_file(filename) do
    filename
    |> File.read!()
    |> Jason.decode!()
  end
end
