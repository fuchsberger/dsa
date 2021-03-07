defmodule DsaWeb.RollController do
  @moduledoc """
  Handles user actions that result in trials
  """
  use DsaWeb, :controller

  import DsaWeb.LogLive, only: [broadcast: 2]

  alias Dsa.{Accounts, Event}

  def action(conn, _) do
    character_id = conn.params["character_id"]
    character = Accounts.get_user_character!(conn.assigns.current_user, character_id)
    group = Accounts.get_user_group!(conn.assigns.current_user)

    args = [conn, conn.params, group, character]
    apply(__MODULE__, action_name(conn), args)
  end

  def skill(conn, %{"skill_roll" => roll_params}, group, character) do
    case Event.create_skill_roll(character, group, roll_params) do
      {:ok, skill_roll} ->
        skill_roll = Dsa.Repo.preload(skill_roll, [:character, :skill])
        broadcast(group.id, {:log, skill_roll})
        redirect(conn, to: Routes.character_skill_path(conn, :index, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.warn inspect changeset
        redirect(conn, to: Routes.character_skill_path(conn, :index, character))
    end
  end
end
