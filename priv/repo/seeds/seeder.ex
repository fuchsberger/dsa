defmodule Dsa.Repo.Seeder do
  @moduledoc """
  This file allows to update all DSA static Data.
  """
  alias Dsa.Repo.Seeds.SkillSeeder

  def seed do
    SkillSeeder.reseed()
  end
end
