defmodule DsaWeb.TrialController do
  @moduledoc """
  Handles user actions that result in trials
  """
  use DsaWeb, :controller

  import DsaWeb.LogLive, only: [broadcast: 2]

  alias Dsa.Event
  alias Dsa.Data.Skill

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def skill(conn, %{"skill_roll" => params}, %{active_character: character} = current_user) do
    changeset = Dsa.UI.change_skill_roll(params)

    if changeset.valid? do
      skill_id = Ecto.Changeset.get_field(changeset, :id)
      modifier = Ecto.Changeset.get_field(changeset, :modifier)
      traits = Enum.map(Skill.traits(skill_id), & Map.get(character, &1))
      level = Map.get(character, Skill.field(skill_id))
      type = Dsa.Event.Log.Type.SkillRoll.value()

      params = Dsa.Trial.handle_trial_event(
        traits,
        level,
        modifier,
        current_user.group_id,
        character.id,
        type,
        skill_id
      )

      case Event.create_log(params) do
        {:ok, log} ->
          broadcast(current_user.group_id, {:log, Event.preload_character_name(log)})

          redirect(conn, to: Routes.character_path(conn, :skills, character))

        {:error, changeset} ->
          Logger.error("Error occured while creating log entry: #{inspect(changeset)}")

          conn
          |> put_flash(:error, gettext("Error occured while creating log entry."))
          |> redirect(to: Routes.character_path(conn, :skills, character))
      end
    else
      Logger.warn inspect  changeset

      conn
      |> put_flash(:error, gettext("Invalid Form Data.")) # Hack Attempt
      |> redirect(to: Routes.character_path(conn, :skills, character))
    end
  end
end
