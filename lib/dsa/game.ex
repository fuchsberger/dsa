defmodule Dsa.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false
  alias Dsa.Repo

  alias Dsa.Accounts
  alias Dsa.Game.Character

  def list_characters do
    Repo.all(Character)
  end

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

  defp user_characters_query(query, %Accounts.User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id)
  end

  def get_character!(id), do: Repo.get!(Character, id)

  def create_character(%Accounts.User{} = user, attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end
end
