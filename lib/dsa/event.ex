defmodule Dsa.Event do
  @moduledoc """
  The Event context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Event.{TalentRoll, TraitRoll}

  # Traits & Talent Rolls
  def create_trait_roll(attrs \\ %{}) do
    %TraitRoll{}
    |> TraitRoll.changeset(attrs, :create)
    |> Repo.insert()
  end

  def create_talent_roll(attrs \\ %{}) do
    %TalentRoll{}
    |> TalentRoll.changeset(attrs, :create)
    |> Repo.insert()
  end

  def change_roll(roll, attrs \\ %{})
  def change_roll(%TraitRoll{} = roll, attrs), do: TraitRoll.changeset(roll, attrs)
  def change_roll(%TalentRoll{} = roll, attrs), do: TalentRoll.changeset(roll, attrs)

  def delete_roll!(%TraitRoll{} = roll), do: Repo.delete!(roll)
  def delete_roll!(%TalentRoll{} = roll), do: Repo.delete!(roll)
end
