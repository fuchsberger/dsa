defmodule Dsa.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false
  alias Dsa.Repo

  import Ecto.Changeset

  alias Dsa.Accounts
  alias Dsa.Game.{Character, CharacterSkill, Group, Skill}

  def list_characters, do: Repo.all(Character)

  def list_user_characters(%Accounts.User{} = user) do
    Character
    |> user_characters_query(user)
    |> Repo.all()
  end

  def get_user_character!(%Accounts.User{} = user, id) do
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

  defp user_characters_query(query, %Accounts.User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id)
  end

  defp user_characters_query(query, user_id) do
    from(v in query, where: v.user_id == ^user_id)
  end

  def sort_skills(%Character{} = character) do
    character = Repo.preload(character, [character_skills: :skill])
    sorted_skills = Enum.sort_by(character.character_skills, & &1.skill.name)
    Map.put(character, :character_skills, sorted_skills)
  end

  def create_character(%Accounts.User{} = user, attrs \\ %{}) do
    case (
      %Character{}
      |> Character.changeset(attrs)
      |> put_assoc(:user, user)
      |> Repo.insert()
    ) do
      {:ok, character} ->
        # add all standard skills to character
        skills = Repo.all(from(s in Skill, select: s.id, where: s.category != "Speziell"))
        Enum.each(skills, & add_skill!(character.id, &1))
        {:ok, sort_skills(character)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> cast_assoc(:character_skills, with: &Dsa.Game.CharacterSkill.changeset/2)
    |> Repo.update()
  end

  def delete_character!(character), do: Repo.delete!(character)

  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  def list_skills, do: Repo.all(from(s in Skill, order_by: s.name))

  # used for seeding
  def create_skill!(category, probe, name, be \\ nil) do
    [e1, e2, e3] = String.split(probe, "/")

    %Skill{}
    |> Skill.changeset(%{ name: name, category: category, e1: e1, e2: e2, e3: e3, be: be })
    |> Repo.insert!()
  end

  def add_skill!(character_id, skill_id) do
    %CharacterSkill{}
    |> CharacterSkill.changeset(%{character_id: character_id, skill_id: skill_id})
    |> Repo.insert!()
  end
end
