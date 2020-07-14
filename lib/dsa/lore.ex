defmodule Dsa.Lore do
  @moduledoc """
  The Lore context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Lore.Skill

  def list_skills, do: Repo.all(from(s in Skill, order_by: [s.category, s.name]))

  # used for seeding
  def create_skill!(category, probe, name, be \\ nil) do
    [e1, e2, e3] =
      case String.split(probe, "/") do
        [e1] -> [e1, nil, nil]
        [e1, e2] -> [e1, e2, nil]
        [e1, e2, e3] -> [e1, e2, e3]
      end

    %Skill{}
    |> Skill.changeset(%{ name: name, category: category, e1: e1, e2: e2, e3: e3, be: be })
    |> Repo.insert!()
  end
end
