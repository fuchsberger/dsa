defmodule Dsa.Event do
  @moduledoc """
  The Event context.
  """
  import Ecto.Changeset, only: [get_field: 2, put_assoc: 3, put_change: 3]
  import Ecto.Query, warn: false

  alias Dsa.{Repo, Trial}
  alias Dsa.Characters.Character
  alias Dsa.Event.{Setting, Log, SkillRoll, SpellRoll, TraitRoll, MainLog}

  require Logger

  # LOGS

  @doc """
  Lists the latest 200 log entries of all types and merges them in a single list sorted by date (desc).

  """
  def list_logs(group_id) do
    # TODO: Optimize query (limit, only load required fields, load as map)
    group =
      Repo.get!(
        from(g in Dsa.Accounts.Group,
          preload: [
            skill_rolls: [:character, :skill],
            spell_rolls: [:character, :spell],
            main_logs: []
          ]
        ),
        group_id
      )

    # TODO: add other types of logs (all logs require inserted_at timestamps)
    entries = group.skill_rolls ++ group.spell_rolls ++ group.main_logs
    IO.inspect("MAINLOG")
    IO.inspect(group.main_logs)

    entries
    |> Enum.sort(&(&1.inserted_at > &2.inserted_at))
    |> Enum.take(200)
  end

  def change_log(attrs \\ %{}), do: Log.changeset(%Log{}, attrs)

  def create_log(attrs), do: Repo.insert(Log.changeset(%Log{}, attrs))

  @doc """
  Deletes all types of logs for a given Group
  """
  def delete_logs!(group_id) do
    Repo.delete_all(from(l in Log, where: l.group_id == ^group_id))
    Repo.delete_all(from(r in SkillRoll, where: r.group_id == ^group_id))
    Repo.delete_all(from(r in SpellRoll, where: r.group_id == ^group_id))
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

  def create_skill_roll(character, group, attrs) do
    changeset = change_skill_roll(attrs)

      change = %{
        left: "hello!",
        right: "hello right",
        character: character,
        type: MainLog.Type.NotSpecified,
        group_id: 1,
      }
      MainLog.changeset(%MainLog{}, change)
      |> put_assoc(:group, group)
      |> put_assoc(:character, character)
      |> IO.inspect()
      |> Repo.insert()



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
