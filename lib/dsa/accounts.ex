defmodule Dsa.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query
  alias Dsa.Repo
  alias Dsa.Accounts.User

  def get_user(id) do
    Repo.get(user_query(), id)
  end

  def get_user!(id) do
    Repo.get!(user_query(), id)
  end

  def get_user_by(params) do
    Repo.get_by(user_query(), params)
  end

  defp user_query, do: from(u in User, preload: :characters)

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
end
