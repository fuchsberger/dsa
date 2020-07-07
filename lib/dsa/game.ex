defmodule Dsa.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false
  alias Dsa.Repo

  import Ecto.Changeset

  alias Dsa.Accounts
  alias Dsa.Game.{Character, Group, Skill}

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
  end

  def get_user_character!(user_id, id) do
    Character
    |> user_characters_query(user_id)
    |> Repo.get!(id)
  end

  defp user_characters_query(query, %Accounts.User{id: user_id}) do
    from(v in query, preload: [:traits, :skills], where: v.user_id == ^user_id)
  end

  defp user_characters_query(query, user_id) do
    from(v in query, preload: [:traits, :skills], where: v.user_id == ^user_id)
  end

  def get_character!(id), do: Repo.get!(Character, id)

  def create_character(%Accounts.User{} = user, attrs \\ %{}) do
    %Character{}
    |> Character.changeset(Map.merge(attrs, %{
      "mu" => 8, "kl" => 8, "in" => 8, "ch" => 8,"ff" => 8,"ge" => 8, "ko" => 8, "kk" => 8
      }))
    |> put_assoc(:user, user)
    |> Repo.insert()
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  def delete_character(%Character{} = character), do: Repo.delete(character)

  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  # def create_skill!(attrs \\ %{}) do
  #   %Skill{}
  #   |> Skill.changeset(attrs)
  #   |> Repo.insert!()
  # end

  # used for seeding
  def create_skill!(category, probe, name, be \\ nil) do
    [e1, e2, e3] = String.split(probe, "/")

    %Skill{}
    |> Skill.changeset(%{ name: name, category: category, e1: e1, e2: e2, e3: e3, be: be })
    |> Repo.insert!()
  end
end
