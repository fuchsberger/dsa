defmodule Dsa.Lore do
  @moduledoc """
  The Lore context.
  """
  import Ecto.Query, warn: false
  require Logger

  alias Dsa.Repo
  alias Dsa.Lore.{Armor, CombatSkill, Skill, Species, Trait, MWeapon, FWeapon}

  # list lore elements
  def list_armors, do: Repo.all(from(s in Armor, order_by: s.name))
  def list_skills, do: Repo.all(from(s in Skill, order_by: [s.category, s.name]))
  def list_combat_skills, do: Repo.all(from(s in CombatSkill, order_by: [s.ranged, s.name]))
  def list_mweapons, do: Repo.all(from(w in MWeapon, preload: :combat_skill, order_by: w.name))
  def list_fweapons, do: Repo.all(from(w in FWeapon, preload: :combat_skill, order_by: w.name))
  def list_traits, do: Repo.all(from(t in Trait, order_by: t.name))

  def options(type) do
    case type do
      :armors -> from(a in Armor)
      :species -> from(a in Species)
    end
    |> select([e], {e.name, e.id})
    |> order_by(:name)
    |> Repo.all()
  end

  def create_skill(params) do
    %Skill{}
    |> change_skill(params)
    |> Repo.insert()
  end

  def change_skill(%Skill{} = skill, attrs \\ %{}), do: Skill.changeset(skill, attrs)

  def seed do
    Enum.each([Armor, CombatSkill, Skill, Species, Trait, MWeapon, FWeapon], fn schema ->
      Enum.each(schema.entries(), fn %{name: name} = params ->
        case Repo.get_by(schema, name: name) do
          nil  -> struct(schema)
          entry -> entry
        end
        |> schema.changeset(params)
        |> Repo.insert_or_update!()

        Logger.debug("#{name} updated...")
      end)
      Logger.info("All entries in #{Atom.to_string(schema)} updated.")
    end)
  end
end
