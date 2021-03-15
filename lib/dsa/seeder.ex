defmodule Dsa.Data.Seeder do
  @moduledoc """
  This file allows to update all static DSA Data.
  """
  alias Dsa.Data

  require Logger

  @data_path "priv/repo/data"

  def seed do
    seed(:skills)
  end

  def seed(:skills) do
    seed_entries = read_file("#{@data_path}/skills.json")
    skills = Data.list_skills()

    Enum.each(seed_entries, fn entry ->

      [t1, t2, t3] = DsaWeb.DsaHelpers.traits(entry["probe"])

      params = %{
        id: entry["id"],
        sf: entry["sf"],
        be: entry["be"],
        name: entry["name"],
        category: entry["category"],
        t1: t1,
        t2: t2,
        t3: t3
      }

      case Enum.find(skills, & &1.id == params.id) do
        nil -> Data.create_skill!(params)
        skill -> Data.update_skill!(skill, params)
      end
    end)
  end

  defp read_file(filename) do
    filename
    |> File.read!()
    |> Jason.decode!()
  end
end
