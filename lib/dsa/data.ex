defmodule Dsa.Data do
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Data.Skill
  alias Dsa.Data.Spell

  def list_skills do
    from(s in Skill, order_by: [s.category, s.name])
    |> Repo.all()
  end

  def get_skill!(id), do: Repo.get!(Skill, id)

  def create_skill(attrs) do
    %Skill{}
    |> Skill.changeset(attrs)
    |> Repo.insert()
  end

  def create_skill!(attrs) do
    %Skill{}
    |> Skill.changeset(attrs)
    |> Repo.insert!()
  end

  def update_skill(%Skill{} = skill, attrs) do
    skill
    |> Skill.changeset(attrs)
    |> Repo.update()
  end

  def update_skill!(%Skill{} = skill, attrs) do
    skill
    |> Skill.changeset(attrs)
    |> Repo.update!()
  end

  def delete_skill(%Skill{} = skill), do: Repo.delete(skill)

  def change_skill(%Skill{} = skill, attrs \\ %{}), do: Skill.changeset(skill, attrs)

  # SPELLS

  def list_spells do
    from(s in Spell, order_by: [desc: s.ritual, asc: s.traditions, asc: s.name])
    |> Repo.all()
  end

  def get_spell!(id), do: Repo.get!(Spell, id)

  def create_spell(attrs) do
    %Spell{}
    |> Spell.changeset(attrs)
    |> Repo.insert()
  end

  def create_spell(attrs) do
    %Spell{}
    |> Spell.changeset(attrs)
    |> Repo.insert!()
  end

  def update_spell(%Spell{} = spell, attrs) do
    spell
    |> Spell.changeset(attrs)
    |> Repo.update()
  end

  def update_spell!(%Spell{} = spell, attrs) do
    spell
    |> Spell.changeset(attrs)
    |> Repo.update!()
  end

  def delete_spell(%Spell{} = spell), do: Repo.delete(spell)

  def change_spell(%Spell{} = spell, attrs \\ %{}), do: Spell.changeset(spell, attrs)
end
