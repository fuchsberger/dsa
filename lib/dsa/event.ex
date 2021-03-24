defmodule Dsa.Event do
  @moduledoc """
  The Event context.
  """
  import Ecto.Changeset, only: [get_field: 2, put_assoc: 3, put_change: 3]
  import Ecto.Query, warn: false

  alias Dsa.{Repo, Trial}
  alias Dsa.Characters.Character
  alias Dsa.Event.{Setting, Log, SkillRoll, SpellRoll, MainLog}

  require Logger

  # LOGS
  def list(group_id, limit \\ 20) do
    from(e in MainLog,
      order_by: [desc: e.inserted_at],
      where: e.group_id == ^group_id,
      limit: ^limit
    )
    |> Repo.all()
  end

  def change_log(attrs \\ %{}), do: MainLog.changeset(%MainLog{}, attrs)

  def create_log(attrs), do: Repo.insert(MainLog.changeset(%MainLog{}, attrs))

  @doc """
  Deletes all types of logs for a given Group
  """
  def delete_logs!(group_id) do
    Repo.delete_all(from(l in Log, where: l.group_id == ^group_id))
    Repo.delete_all(from(l in MainLog, where: l.group_id == ^group_id))
    # Repo.delete_all(from(r in TraitRoll, where: r.group_id == ^group_id))
  end

  # Settings (Group View, does not persist in database)
  def change_settings(attrs \\ %{}), do: Setting.changeset(%Setting{}, attrs)

  def preload_character_name(struct) do
    Repo.preload(struct, character: from(c in Character, select: c.name))
  end

  # Skill Rolls
  def change_skill_roll(attrs \\ %{}), do: SkillRoll.changeset(%SkillRoll{}, attrs)

  # Spell Rolls
  def change_spell_roll(attrs \\ %{}), do: SpellRoll.changeset(%SpellRoll{}, attrs)

  defp trial_result_type(quality, critical?) do
    case {quality, critical?} do
      {0, true} ->
        {"✗ K!", MainLog.ResultType.Failure}

      {_, true} ->
        {"✓ K!", MainLog.ResultType.Success}

      {0, false} ->
        {"✗", MainLog.ResultType.Failure}

      {_, false} ->
        {"✓ #{quality}", MainLog.ResultType.Success}
    end
  end

  def create_skill_roll(character, group, attrs) do
    changeset = change_skill_roll(attrs)

    if changeset.valid? do
      modifier = get_field(changeset, :modifier)
      skill_id = get_field(changeset, :skill_id)

      # get required inputs

      %{level: level, skill: %{probe: probe}} =
        character
        |> Repo.preload(character_skills: [:skill])
        |> Map.get(:character_skills)
        |> Enum.find(&(&1.skill_id == skill_id))

      dice = Trial.roll()
      [t1, t2, t3] = get_character_trait_values(character, probe)

      # produce roll results
      {quality, critical?} = Trial.result(dice, t1, t2, t3, level, modifier)

      {result, result_type} = trial_result_type(quality, critical?)
      skill_name = Dsa.Repo.get!(Dsa.Data.Skill, skill_id).name

      change = %{
        left: "#{skill_name}",
        right: "#{modifier}",
        result: "#{result}",
        roll: dice,
        character: character,
        character_name: character.name,
        type: MainLog.Type.SkillRoll,
        result_type: result_type,
        group_id: group.id
      }

      MainLog.changeset(%MainLog{}, change)
      |> put_assoc(:group, group)
      |> put_assoc(:character, character)
      |> Repo.insert()
    else
      changeset
    end
  end

  def create_spell_roll(character, group, attrs) do
    changeset = change_spell_roll(attrs)

    if changeset.valid? do
      modifier = get_field(changeset, :modifier)
      spell_id = get_field(changeset, :spell_id)

      # get required inputs

      %{level: level, spell: %{probe: probe}} =
        character
        |> Repo.preload(character_spells: [:spell])
        |> Map.get(:character_spells)
        |> Enum.find(&(&1.spell_id == spell_id))

      dice = Trial.roll()
      [t1, t2, t3] = get_character_trait_values(character, probe)

      # produce roll results
      {quality, critical?} = Trial.result(dice, t1, t2, t3, level, modifier)

      {result, result_type} = trial_result_type(quality, critical?)
      spell_name = Dsa.Repo.get!(Dsa.Data.Spell, spell_id).name

      change = %{
        left: "#{spell_name}",
        right: "#{modifier}",
        result: "#{result}",
        roll: dice,
        character: character,
        character_name: character.name,
        type: MainLog.Type.SpellRoll,
        result_type: result_type,
        group_id: group.id
      }

      MainLog.changeset(%MainLog{}, change)
      |> put_assoc(:group, group)
      |> put_assoc(:character, character)
      |> Repo.insert()

      changeset
      |> put_change(:roll, dice)
      |> put_change(:quality, quality)
      |> put_change(:critical, critical?)
      |> put_assoc(:character, character)
      |> put_assoc(:group, group)
      |> Repo.insert()

    else
      changeset
    end
  end

  # Trait Rolls
  # def change_trait_roll(attrs), do: TraitRoll.changeset(%TraitRoll{}, attrs)

  # def create_trait_roll(character, group, attrs) do

  #   changeset =
  #     %TraitRoll{}
  #     |> TraitRoll.changeset(attrs)
  #     |> put_assoc(:character, character)
  #     |> put_assoc(:group, group)

  #   if changeset.valid? do
  #     trait = get_field(changeset, :trait)
  #     modifier = get_field(changeset, :modifier)

  #     {dices, success?, critically?} = Dsa.Trial.handle_trait_event(character, trait, modifier)

  #     changeset
  #     |> put_change(:dice, dices)
  #     |> put_change(:success, success?)
  #     |> put_change(:critical, critically?)
  #     |> Repo.insert()
  #   else
  #     changeset
  #   end
  # end

  # Given a character and a probe, returns the characters traits for it.
  # Example: {:mu, :kl, :ch} -> [12, 13, 13]
  defp get_character_trait_values(%Character{} = character, {t1, t2, t3}) do
    [Map.get(character, t1), Map.get(character, t2), Map.get(character, t3)]
  end
end
