defmodule Dsa.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.{Changeset, Query}

  require Logger

  alias Dsa.Repo
  alias Dsa.Accounts.{Group, User}
  alias Dsa.Characters
  alias Dsa.Characters.Character

  ##########################################################
  # User related APIs

  def list_users, do: Repo.all(User)

  def admin?(user_id), do: Repo.get(from(u in User, select: u.admin), user_id)

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id) do
    User
    |> preload_characters()
    |> Repo.get(id)
  end

  def get_user_by(params) do
    User
    |> preload_characters()
    |> Repo.get_by(params)
  end

  def preload_characters(%User{} = user) do
    Repo.preload user, [characters: character_query()]
  end

  def preload_characters(query) do
    preload query, [characters: ^character_query()]
  end

  defp character_query, do: from(c in Character, select: {c.id, c.name}, order_by: c.name)

  def authenticate_by_email_and_password(email, given_pass) do
    user = get_user_by(email: email)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        case user.confirmed do
          true -> {:ok, user}
          false -> {:error, :unconfirmed}
        end

      user ->
        {:error, :invalid_credentials}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :invalid_credentials}
    end
  end

  ##########################################################
  # Character related APIs

  def change_user(%User{} = user, params \\ %{}), do: User.changeset(user, params)

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

  def manage_user!(%User{} = user, params) do
    user
    |> User.manage_changeset(params)
    |> Repo.update!()
  end

  def change_email(params), do: User.email_changeset(%User{}, params)

  def change_password(%User{} = user, params) do
    User.password_changeset(user, params)
  end

  def update_password(%User{} = user, params) do
    user
    |> User.password_changeset(params)
    |> Repo.update()
  end

  def reset_user(%User{} = user) do
    user
    |> change()
    |> User.put_token()
    |> Repo.update()
  end

  def update_user(%User{} = user, params \\ %{}) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  def delete_user(%User{} = user), do: Repo.delete(user)

  ##########################################################
  # Group related APIs

  def list_groups do
    from(g in Group, preload: [
      master: ^from(u in User, select: u.username),
      users: ^from(u in User, select: u.id)
    ])
    |> Repo.all()
  end

  def list_group_options, do: Repo.all(from(g in Group, select: {g.name, g.id}, order_by: g.name))

  def get_user_group!(%User{} = user) do
    user
    |> Repo.preload(:group)
    |> Map.get(:group)
  end

  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  used in live view
  """
  def get_group_characters!(group_id) do
    group =
      Repo.get!(from(g in Group, preload: [
        users: ^from(u in User, preload: [characters: ^Characters.character_query()])
      ]), group_id)

    group.users
    |> Enum.map(& &1.characters)
    |> List.flatten()
    |> Enum.sort_by(&(&1.ini_basis), :desc) # sort order: ini --> ini_basis
    |> Enum.sort_by(&(&1.ini), :desc)
  end

  @doc """
  Creating a group makes creator the master automatically.
  """
  def create_group(%User{} = user, attrs) do
    %Group{}
    |> Group.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:master, user)
    |> Repo.insert()
  end

  def change_group(%Group{} = group, attrs \\ %{}), do: Group.changeset(group, attrs)

  def delete_group(%Group{} = group), do: Repo.delete(group)

  def join_group(%User{} = user, %Group{} = group) do
    user
    |> Repo.preload(:group)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:group, group)
    |> Repo.update()
  end

  def leave_group(%User{} = user) do
    user
    |> Repo.preload(:group)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:group, nil)
    |> Repo.update()
  end

  def delete(struct), do: Repo.delete(struct)
end
