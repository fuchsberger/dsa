defmodule Dsa.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.{Changeset, Query}

  alias Dsa.Repo
  alias Dsa.Accounts.{Character, CharacterSkill, Group, User}
  alias Dsa.Lore.Skill

  def get_user(id), do:  Repo.get(user_query(), id)

  def get_user_by(params), do: Repo.get_by(user_query(), params)

  defp user_query() do
    from(u in User, preload: [characters: ^from(c in Character, select: {c.id, c.name})])
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

  def change_registration(%User{} = user \\ %User{}, params \\ %{}) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def set_role(%User{} = user, role, value) do
    user
    |> User.set_role(role, value)
    |> Repo.update()
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
    Character
    |> user_characters_query(user_id)
    |> Repo.get!(id)
    |> sort_skills()
  end

  def get_character!(id) do
    case Repo.get!(from(c in Character, preload: [character_skills: :skill]), id) do
      nil -> nil
      character -> sort_skills(character)
    end
  end

  defp user_characters_query(query, %User{id: user_id}) do
    from(v in query, preload: :group, where: v.user_id == ^user_id)
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
        skills = Repo.all(Skill)
        Enum.each(skills, & add_skill!(character.id, &1))
        {:ok, sort_skills(character)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> cast_assoc(:character_skills, with: &CharacterSkill.changeset/2)
    |> Repo.update()
  end

  def delete_character!(character), do: Repo.delete!(character)

  def change_active_character(attrs \\ %{}), do: Character.active_changeset(%Character{}, attrs)

  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  def list_groups, do: Repo.all(from(g in Group, preload: :master))

  def change_group(%Group{} = group \\ %Group{}, attrs \\ %{}), do: Group.changeset(group, attrs)

  def get_group!(id) do
    Repo.get!(from(g in Group, preload: [
      talent_rolls: [:character],
      trait_rolls: [:character],
      characters: [:user, character_skills: [:skill]]
    ]), id)
  end

  def add_skill!(character_id, skill) do
    level = if skill.category == "Nahkampf" || skill.category == "Fernkampf", do: 6, else: 0
    %CharacterSkill{}
    |> CharacterSkill.changeset(%{character_id: character_id, skill_id: skill.id, level: level})
    |> Repo.insert!()
  end
end
