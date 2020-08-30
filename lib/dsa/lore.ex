defmodule Dsa.Lore do
  @moduledoc """
  The Lore context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Lore.{Armor, Skill}

  def list_armors, do: Repo.all(from(s in Armor, order_by: s.name))

  def armor_options, do: Repo.all(from(a in Armor, select: {a.name, a.id}, order_by: a.name))

  def change_armor(%Armor{} = skill \\ %Armor{}, attrs \\ %{}), do: Armor.changeset(skill, attrs)

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
