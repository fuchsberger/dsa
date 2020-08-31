defmodule Dsa.Lore do
  @moduledoc """
  The Lore context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Lore.{Armor, CombatSkill, Skill, Weapon}

  def list_armors, do: Repo.all(from(s in Armor, order_by: s.name))

  def armor_options, do: Repo.all(from(a in Armor, select: {a.name, a.id}, order_by: a.name))

  def change_armor(skill, attrs \\ %{}), do: Armor.changeset(skill, attrs)

  def list_skills, do: Repo.all(from(s in Skill, order_by: [s.category, s.name]))

  def change_skill(skill, attrs \\ %{}), do: Skill.changeset(skill, attrs)


  def get_combat_skill(id), do: Repo.get!(CombatSkill, id)

  def list_combat_skills, do: Repo.all(from(s in CombatSkill, order_by: [s.ranged, s.name]))

  def change_combat_skill(skill, attrs \\ %{}), do: CombatSkill.changeset(skill, attrs)

  def list_weapons, do: Repo.all(from(w in Weapon, preload: :combat_skill, order_by: [w.combat_skill_id, w.name]))

  def change_weapon(skill, attrs \\ %{}), do: Weapon.changeset(skill, attrs)

  def cast_options do
    from(s in Skill,
      select: {s.name, s.id},
      order_by: s.name,
      where: s.category == "Zauber" or s.category == "Liturgie"
    ) |> Repo.all()
  end
end
