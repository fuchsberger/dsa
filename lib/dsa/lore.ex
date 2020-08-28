defmodule Dsa.Lore do
  @moduledoc """
  The Lore context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Lore.Skill

  def list_skills, do: Repo.all(from(s in Skill, order_by: [s.category, s.name]))

  def change_skill(%Skill{} = skill \\ %Skill{}, attrs \\ %{}), do: Skill.changeset(skill, attrs)

  def cast_options do
    from(s in Skill,
      select: {s.name, s.id},
      order_by: s.name,
      where: s.category == "Zauber" or s.category == "Liturgie"
    ) |> Repo.all()
  end

end
