defmodule Dsa.Repo.Seeder do
  @moduledoc """
  This file allows to update all DSA static Data.
  """
  alias Dsa.Accounts
  alias Dsa.Repo.Seeds.SkillSeeder

  require Logger

  def seed do
    SkillSeeder.reseed()
  end

  @doc """
  Confirms a user if not confirmed already.
  """
  def confirm(email) when is_binary(email) do
    case Accounts.get_user_by(email: email) do
      nil -> Logger.error("User does not exist.")
      user ->
        Accounts.manage_user!(user, %{confirm: true, token: nil})
        Logger.info("Confirmed user #{user.username}.")
    end
  end

  @doc """
  Makes a user with a given email an admin if present.
  Execute this function via an interactive shell (iex).
  Can alternatively also be used to demote an admin.
  """
  def make_admin(email, admin \\ true) when is_binary(email) do
    case Accounts.get_user_by(email: email) do
      nil -> Logger.error("User does not exist.")
      user ->
        Accounts.manage_user!(user, %{admin: admin})
        Logger.info("Changed admin status of #{user.username} to #{user.admin}")
    end
  end
end
