defmodule Dsa.Data.Seeder do
  @moduledoc """
  This file allows to insert / update all static DSA Data found under priv/repo/data.
  """
  alias Dsa.Data

  @data_path "priv/repo/data"

  def seed do
    seed(:skills)
    seed(:spells)
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

  def seed(:spells) do
    seed_entries = read_file("#{@data_path}/spells.json")
    spells = Data.list_spells()

    Enum.each(seed_entries, fn entry ->

      [t1, t2, t3] = DsaWeb.DsaHelpers.traits(entry["probe"])

      params = %{
        id: entry["id"],
        sf: entry["sf"],
        name: entry["name"],
        ritual: entry["ritual"],
        traditions: entry["traditions"],
        t1: t1,
        t2: t2,
        t3: t3
      }

      case Enum.find(spells, & &1.id == params.id) do
        nil -> Data.create_spell!(params)
        spell -> Data.update_spell!(spell, params)
      end
    end)
  end

  defp read_file(filename) do
    filename
    |> File.read!()
    |> Jason.decode!()
  end
end
