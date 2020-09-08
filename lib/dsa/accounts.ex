defmodule Dsa.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.{Changeset, Query}

  alias Dsa.Repo
  alias Dsa.Accounts.{Character, CharacterCombatSkill, CharacterSkill, CharacterTrait, Group, User}
  alias Dsa.Lore.{CombatSkill, Skill, Trait}


  @sorted_combat_skills from(s in CombatSkill, order_by: s.name)
  @sorted_skills from(s in Skill, order_by: [s.category, s.name])
  @sorted_traits from(t in Trait, order_by: t.name)

  @character_preloads [
    :species,
    :group,
    :user,
    :character_armors,
    :character_mweapons,
    :character_fweapons,
    :character_skills,
    :character_combat_skills,
    :character_traits,
    special_skills: [:special_skill],
    combat_skills: @sorted_combat_skills,
    skills: @sorted_skills,
    traits: @sorted_traits
  ]

  def get_user(id), do:  Repo.get(user_query(), id)

  def get_user_by(params), do: Repo.get_by(user_query(), params)

  defp user_query() do
    from(u in User, preload: [characters: :group])
  end

  def authenticate_by_username_and_pass(username, given_pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  def list_users, do: Repo.all(User)

  def list_user_characters(user_id) do
    from(c in Character, preload: ^@character_preloads, where: c.user_id == ^user_id)
    |> Repo.all()
  end

  def change_registration(%User{} = user, params \\ %{}) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def delete_user!(user), do: Repo.delete!(user)

  def list_characters(%User{} = user) do
    Character
    |> user_characters_query(user)
    |> Repo.all()
  end

  def get_user_character!(%User{} = user, id) do
    Character
    |> user_characters_query(user)
    |> Repo.get!(id)
    |> sort_skills()
  end

  def get_user_character!(user_id, id) do
    from(c in Character,
      preload: ^@character_preloads,
      where: c.user_id == ^user_id and c.id == ^id
    )
    |> Repo.get!(id)
  end

  def preload(%Character{} = character) do
    Repo.preload(character, @character_preloads, force: true)
  end

  defp user_characters_query(query, %User{id: user_id}) do
    from(v in query, preload: [
      :group,
      character_skills: :skill,
      character_combat_skills: :combat_skill
    ], where: v.user_id == ^user_id)
  end

  defp user_characters_query(query, user_id) do
    from(v in query, preload: :group, where: v.user_id == ^user_id)
  end

  def sort_skills(%Character{} = character) do
    character = Repo.preload(character, [character_skills: :skill])
    sorted_skills = Enum.sort_by(character.character_skills, & &1.skill.name)
    Map.put(character, :character_skills, sorted_skills)
  end

  def create_character(%User{} = user, attrs \\ %{}) do
    case (
      %Character{}
      |> Character.changeset(attrs)
      |> put_assoc(:user, user)
      |> Repo.insert()
    ) do
      {:ok, character} ->
        # add all standard skills to character
        CombatSkill
        |> Repo.all()
        |> Enum.each(& add_combat_skill!(character.id, &1))

        from(s in Skill, where: s.category != 6 and s.category != 7)
        |> Repo.all()
        |> Enum.each(& add_skill!(character.id, &1))

        {:ok, sort_skills(character)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> cast_assoc(:character_combat_skills, with: &CharacterCombatSkill.changeset/2)
    |> cast_assoc(:character_skills, with: &CharacterSkill.changeset/2)
    |> Repo.update()
  end

  def update_character(%Character{} = character, attrs, :combat) do
    character
    |> Character.combat_changeset(attrs)
    |> Repo.update()
  end

  def add_character_skill(character_id, skill_id) do
    %CharacterSkill{}
    |> CharacterSkill.changeset(%{character_id: character_id, skill_id: skill_id})
    |> Repo.insert()
  end

  def remove_character_skill(character_id, skill_id) do
    from(c in CharacterSkill, where: c.character_id == ^character_id and c.skill_id == ^skill_id)
    |> Repo.one!()
    |> Repo.delete()
  end

  def delete_character!(character), do: Repo.delete!(character)

  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  def change_character(%Character{} = character, attrs, :combat) do
    Character.combat_changeset(character, attrs)
  end

  def list_groups, do: Repo.all(from(g in Group, preload: :master))

  def list_group_options, do: Repo.all(from(g in Group, select: {g.name, g.id}, order_by: g.name))

  def create_group(attrs) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  def change_group(%Group{} = group, attrs \\ %{}), do: Group.changeset(group, attrs)

  def get_group!(id) do
    Repo.get!(from(g in Group, preload: [
      general_rolls: [:character],
      talent_rolls: [:character, :skill],
      trait_rolls: [:character],
      routine: [:character, :skill],
      characters: ^@character_preloads
    ]), id)
  end

  def add_character_trait(params) do
    %CharacterTrait{}
    |> CharacterTrait.changeset(params)
    |> Repo.insert()
  end

  def remove_character_trait(character_trait), do: Repo.delete(character_trait)

  def add_combat_skill!(character_id, skill) do
    %CharacterCombatSkill{}
    |> CharacterCombatSkill.changeset(%{character_id: character_id, combat_skill_id: skill.id})
    |> Repo.insert!()
  end

  def add_skill!(character_id, skill) do
    %CharacterSkill{}
    |> CharacterSkill.changeset(%{character_id: character_id, skill_id: skill.id})
    |> Repo.insert!()
  end

  def delete_character_skill!(character_id, skill_id) do
    from(s in CharacterSkill, where: s.character_id == ^character_id and s.skill_id == ^skill_id)
    |> Repo.one!()
    |> Repo.delete!()
  end
end
