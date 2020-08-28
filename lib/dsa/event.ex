defmodule Dsa.Event do
  @moduledoc """
  The Event context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Event.{GeneralRoll, Setting, TalentRoll, TraitRoll}

  # Traits & Talent Rolls

  def create_general_roll(attrs) do
    %GeneralRoll{}
    |> GeneralRoll.changeset(attrs)
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

  def change_roll(roll, attrs \\ %{})
  def change_roll(%GeneralRoll{} = roll, attrs), do: GeneralRoll.changeset(roll, attrs)
  def change_roll(%TraitRoll{} = roll, attrs), do: TraitRoll.changeset(roll, attrs)
  def change_roll(%TalentRoll{} = roll, attrs), do: TalentRoll.changeset(roll, attrs)

  def delete_logs(group_id) do
    from(r in GeneralRoll, where: r.group_id == ^group_id) |> Repo.delete_all
    from(r in TraitRoll, where: r.group_id == ^group_id) |> Repo.delete_all
    from(r in TalentRoll, where: r.group_id == ^group_id) |> Repo.delete_all
  end

  # Settings (Group View, does not persist in database)
  def change_settings(attrs \\ %{}), do: Setting.changeset(%Setting{}, attrs)
end
