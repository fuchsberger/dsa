defmodule Dsa.Lore do
  @moduledoc """
  The Lore context.
  """
  import Ecto.Query, warn: false
  require Logger

  alias Dsa.Repo
  alias Dsa.Lore.{Armor, CombatSkill, SpecialSkill, Skill, MWeapon, FWeapon}

  def list_armors, do: Repo.all(from(s in Armor, order_by: s.name))

  def armor_options, do: Repo.all(from(a in Armor, select: {a.name, a.id}, order_by: a.name))

  def list_skills, do: Repo.all(from(s in Skill, order_by: [s.category, s.name]))

  def change_skill(skill, attrs \\ %{}), do: Skill.changeset(skill, attrs)

  def list_combat_skills, do: Repo.all(from(s in CombatSkill, order_by: [s.ranged, s.name]))

  def list_special_skills, do: Repo.all(from(s in SpecialSkill, preload: :combat_skills, order_by: s.name))

  def list_mweapons do
    Repo.all(from(w in MWeapon, preload: :combat_skill, order_by: w.name))
  end


  def list_fweapons do
    Repo.all(from(w in FWeapon, preload: :combat_skill, order_by: w.name))
  end

  def cast_options do
    from(s in Skill,
      select: {s.name, s.id},
      order_by: s.name,
      where: s.category == "Zauber" or s.category == "Liturgie"
    ) |> Repo.all()
  end

  def seed(:armors) do
    Armor.entries()
    |> Enum.each(fn %{id: id, name: name} = params ->
      case Repo.get(Armor, id) do
        nil  -> %Armor{id: id}
        entry -> entry
      end
      |> Armor.changeset(params)
      |> Repo.insert_or_update!()

      Logger.debug("Armor: #{name} updated...")
    end)
  end

  def seed(:combat_skills) do
    CombatSkill.entries()
    |> Enum.each(fn %{id: id, name: name} = params ->
        case Repo.get(CombatSkill, id) do
          nil  -> %CombatSkill{id: id}
          entry -> entry
        end
        |> CombatSkill.changeset(params)
        |> Repo.insert_or_update!()

        Logger.debug("Combat Skill: #{name} updated...")
      end)
  end

  def seed(:skills) do
    Skill.entries()
    |> Enum.each(fn %{id: id, name: name} = params ->

      case Repo.get(Skill, id) do
        nil  -> %Skill{id: id}
        entry -> entry
      end
      |> Skill.changeset(params)
      |> Repo.insert_or_update!()

      Logger.debug("Skill: #{name} updated...")
    end)
  end

  def seed(:mweapons) do
    MWeapon.entries()
    |> Enum.each(fn %{id: id, name: name} = params ->
      case Repo.get(MWeapon, id) do
        nil  -> %MWeapon{id: id}
        entry -> entry
      end
      |> MWeapon.changeset(params)
      |> Repo.insert_or_update!()

      Logger.debug("Weapon: #{name} updated...")
    end)
  end

  def seed(:fweapons) do
    FWeapon.entries()
    |> Enum.each(fn %{id: id, name: name} = params ->
      case Repo.get(FWeapon, id) do
        nil  -> %FWeapon{id: id}
        entry -> entry
      end
      |> FWeapon.changeset(params)
      |> Repo.insert_or_update!()

      Logger.debug("Weapon: #{name} updated...")
    end)
  end

  def seed(:special_skills) do
    SpecialSkill.entries()
    |> Enum.each(fn {%{id: id, name: name} = params, combat_skills} ->

      combat_skills = Repo.all(from(s in CombatSkill, where: s.id in ^combat_skills))

      case Repo.get(SpecialSkill, id) do
        nil  -> %SpecialSkill{id: id}
        entry -> Repo.preload(entry, :combat_skills)
      end
      |> SpecialSkill.changeset(params)
      |> Ecto.Changeset.put_assoc(:combat_skills, combat_skills)
      |> Repo.insert_or_update!()

      Logger.debug("Special Skill: #{name} updated...")
    end)
  end
end
