defmodule Dsa.Event do
  @moduledoc """
  The Event context.
  """
  import Ecto.Changeset, only: [get_field: 2, put_assoc: 3, put_change: 3]
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Characters.Character
  alias Dsa.Event.{Setting, Log, SkillRoll, TraitRoll}

  require Logger

  def list_logs(group_id) do
    from(l in Log,
      limit: 200,
      order_by: [desc: l.inserted_at],
      preload: [:character],
      where: l.group_id == ^group_id)
    |> Repo.all()
  end

  def change_log(attrs \\ %{}), do: Log.changeset(%Log{}, attrs)

  def create_log(attrs), do: Repo.insert(Log.changeset(%Log{}, attrs))

  @doc """
  Deletes all types of logs for a given Group
  """
  def delete_logs!(group_id) do
    Repo.delete_all(from(l in Log, where: l.group_id == ^group_id))
    Repo.delete_all(from(r in SkillRoll, where: r.group_id == ^group_id))
    Repo.delete_all(from(r in TraitRoll, where: r.group_id == ^group_id))
  end

  # Settings (Group View, does not persist in database)
  def change_settings(attrs \\ %{}), do: Setting.changeset(%Setting{}, attrs)

  def preload_character_name(struct) do
    Repo.preload(struct, character: from(c in Character, select: c.name))
  end

  # Skill Rolls
  def change_skill_roll(attrs), do: SkillRoll.changeset(%SkillRoll{}, attrs)

  def create_skill_roll(character, group, attrs) do

    changeset =
      %SkillRoll{}
      |> SkillRoll.changeset(attrs)
      |> put_assoc(:character, character)
      |> put_assoc(:group, group)

    if changeset.valid? do
      skill_id = get_field(changeset, :skill_id)
      modifier = get_field(changeset, :modifier)

      {dices, quality, critically?} = Dsa.Trial.handle_skill_event(character, skill_id, modifier)


      changeset
      |> put_change(:dice, dices)
      |> put_change(:quality, quality)
      |> put_change(:critical, critically?)
      |> Repo.insert()
    else
      changeset
    end
  end

  # Trait Rolls
  def change_trait_roll(attrs), do: TraitRoll.changeset(%TraitRoll{}, attrs)

  def create_trait_roll(character, group, attrs) do

    changeset =
      %TraitRoll{}
      |> TraitRoll.changeset(attrs)
      |> put_assoc(:character, character)
      |> put_assoc(:group, group)

    if changeset.valid? do
      trait = get_field(changeset, :trait)
      modifier = get_field(changeset, :modifier)

      {dices, success?, critically?} = Dsa.Trial.handle_trait_event(character, trait, modifier)

      changeset
      |> put_change(:dice, dices)
      |> put_change(:success, success?)
      |> put_change(:critical, critically?)
      |> Repo.insert()
    else
      changeset
    end
  end
end
