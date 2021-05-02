defmodule DsaWeb.EventController do
  @moduledoc """
  Handles user actions that result in log entries.
  """
  use DsaWeb, :controller

  import DsaWeb.LogLive, only: [broadcast: 2]

  alias Dsa.{Accounts, Characters, Logs}

  def action(conn, _) do
    character_id = conn.params["character_id"]
    character = if character_id do
      character = Characters.get!(conn.assigns.current_user, character_id)
    else 
      nil
    end

    group = Accounts.get_user_group!(conn.assigns.current_user)

    args = [conn, conn.params, group, character]
    apply(__MODULE__, action_name(conn), args)
  end

  def skill_roll(conn, %{"skill_roll" => roll_params}, group, character) do
    case Logs.create_skill_roll(character, group, roll_params) do
      {:ok, skill_roll} ->
        broadcast(group.id, {:log, skill_roll})
        redirect(conn, to: Routes.character_skill_path(conn, :index, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.warn(inspect(changeset))
        redirect(conn, to: Routes.character_skill_path(conn, :index, character))
    end
  end

  def spell_roll(conn, %{"spell_roll" => roll_params}, group, character) do
    case Logs.create_spell_roll(character, group, roll_params) do
      {:ok, spell_roll} ->
        broadcast(group.id, {:log, spell_roll})
        redirect(conn, to: Routes.character_spell_path(conn, :index, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.warn(inspect(changeset))
        redirect(conn, to: Routes.character_spell_path(conn, :index, character))
    end
  end

  def blessing_roll(conn, %{"blessing_roll" => roll_params}, group, character) do
    case Logs.create_blessing_roll(character, group, roll_params) do
      {:ok, blessing_roll} ->
        broadcast(group.id, {:log, blessing_roll})
        redirect(conn, to: Routes.character_blessing_path(conn, :index, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.warn(inspect(changeset))
        redirect(conn, to: Routes.character_blessing_path(conn, :index, character))
    end
  end

  def dice_table_roll(conn, %{"dice_table_roll" => roll_params}, group, character) do
    case Logs.create_dice_table_roll(group, roll_params) do
      {:ok, dice_table_roll} ->
        broadcast(group.id, {:log, dice_table_roll})
        redirect(conn, to: Routes.dice_table_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.warn(inspect(changeset))
        redirect(conn, to: Routes.dice_table_path(conn, :index))
    end
  end

  # def trait_roll(conn, %{"trait_roll" => roll_params}, group, character) do
  #   case Event.create_trait_roll(character, group, roll_params) do
  #     {:ok, trait_roll} ->
  #       trait_roll = Dsa.Repo.preload(trait_roll, :character)
  #       broadcast(group.id, {:log, trait_roll})
  #       redirect(conn, to: Routes.character_skill_path(conn, :index, character))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       Logger.warn inspect changeset
  #       redirect(conn, to: Routes.character_skill_path(conn, :index, character))
  #   end
  # end
end
