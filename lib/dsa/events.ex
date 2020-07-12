defmodule Dsa.Event do
  @moduledoc """
  The Event context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Event.{TraitRoll}

  # Traits
  def create_trait_roll(attrs \\ %{}) do
    %TraitRoll{}
    |> TraitRoll.changeset(attrs)
    |> Repo.insert()
  end

  def change_trait_roll(%TraitRoll{} = roll, attrs \\ %{}), do: TraitRoll.changeset(roll, attrs)

  def delete_roll!(%TraitRoll{} = roll), do: Repo.delete!(roll)

  # Logs
  # def create_log(attrs), do: Log.changeset(%Log{}, attrs) |> Repo.insert()

  # def change_log(%Log{} = log, attrs \\ %{}), do: Log.changeset(log, attrs)

  # def change_talent_roll(attrs \\ %{}), do: TalentRoll.changeset(%TalentRoll{}, attrs)
end
