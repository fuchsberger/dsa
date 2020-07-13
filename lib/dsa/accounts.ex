defmodule Dsa.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query
  alias Dsa.Repo
  alias Dsa.Accounts.User
  alias Dsa.Game.Character

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

  def list_users do
    Repo.all(User)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
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
end
