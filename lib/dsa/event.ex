defmodule Dsa.Event do
  @moduledoc """
  The Event context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Event.{GeneralRoll, Routine, Setting, TalentRoll, TraitRoll}

  def create_general_roll(attrs) do
    %GeneralRoll{}
    |> GeneralRoll.changeset(attrs)
    |> Repo.insert()
  end

  def create_routine(attrs) do
    %Routine{}
    |> Routine.changeset(attrs)
    |> Repo.insert()
  end

  def create_trait_roll(attrs) do
    %TraitRoll{}
    |> TraitRoll.changeset(attrs)
    |> Repo.insert()
  end

  def create_talent_roll(attrs \\ %{}) do
    %TalentRoll{}
    |> TalentRoll.changeset(attrs, :create)
    |> Repo.insert()
  end

  def delete_logs(group_id) do
    from(r in GeneralRoll, where: r.group_id == ^group_id) |> Repo.delete_all
    from(r in Routine, where: r.group_id == ^group_id) |> Repo.delete_all
    from(r in TraitRoll, where: r.group_id == ^group_id) |> Repo.delete_all
    from(r in TalentRoll, where: r.group_id == ^group_id) |> Repo.delete_all
  end

  # Settings (Group View, does not persist in database)
  def change_settings(attrs \\ %{}), do: Setting.changeset(%Setting{}, attrs)
end
