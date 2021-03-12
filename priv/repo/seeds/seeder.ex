defmodule Dsa.Repo.Seeder do
  @moduledoc """
  This file allows to update all static DSA Data.
  """
  alias Dsa.{Accounts, Data}

  require Logger

  @data_path "priv/repo/seeds/data"

  def seed do
    seed(:skills)
  end

  def seed(:skills) do
    seed_entries = read_file("#{@data_path}/skills.json")
    skills = Data.list_skills()

    Enum.each(seed_entries, fn entry ->

      [t1, t2, t3] = DsaWeb.DsaHelpers.traits(entry["probe"])

      params = %{
        id: entry["id"],
        sf: entry["sf"],
        be: entry["be"],
        name: entry["name"],
        category: entry["category"],
        t1: t1,
        t2: t2,
        t3: t3
      }

      case Enum.find(skills, & &1.id == params.id) do
        nil -> Data.create_skill!(params)
        skill -> Data.update_skill!(skill, params)
      end
    end)
  end

  defp read_file(filename) do
    filename
    |> File.read!()
    |> Jason.decode!()
  end

  @doc """
  Creates a confirmed user with admin privileges.
  Execute this function via an interactive shell (iex).
  Example: Dsa.Repo.Seeder("test@test.de", "Passwort123", "Username")
  """
  def create_admin(email, password, username \\ "Admin") do
    params = %{email: email, username: username, password: password, password_confirm: password}

    case Accounts.register_user(params) do
      {:ok, user} ->
        Accounts.manage_user!(user, %{admin: true, confirmed: true, token: nil})
        Logger.info("Created admin user: #{inspect (user)}")

      {:error, changeset} ->
        Logger.error("Error creating admin user: #{inspect(changeset.errors)}")
    end
  end
end
