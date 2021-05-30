defmodule Dsa.Data do
  @moduledoc """
  The Data context, which contains all static DSA data.
  """

  alias Dsa.Data.Skill

  require Logger

  def init do
    # create data tables
    :ets.new(:skills, [:set, :named_table])

    # populate data tables
    Skill.seed()

    Logger.debug("DSA data tables created.")
  end

  @doc """
  Provides a slug: id keyword list for url friendly accessing of data.
  """
  def slugs(collection) do
    :ets.tab2list(collection)
    |> Enum.map(fn {id, %{name: name}} -> {Dsa.slugify(name), id} end)
  end

  def slug_to_id(collection, slug)  do
    collection
    |> slugs()
    |> Keyword.get(slug)
  end

  @doc """
  Returns a list of all skills sorted by name.
  """
  def list_skills do
    :ets.tab2list(:skills)
    |> Enum.map(fn {_id, skill} -> skill end)
    |> Enum.sort_by(&(&1.id))
  end

  @doc """
  Returns a skill with a given id.
  """
  def get_skill(id) do
    case :ets.lookup(:skills, id) do
      [{_id, skill}] -> skill
      [] -> nil
    end
  end
end
