defmodule Dsa.Event do
  @moduledoc """
  The Event context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Event.{Setting, Log}

  def change_log(attrs \\ %{}), do: Log.changeset(%Log{}, attrs)

  def create_log(attrs), do: Repo.insert(Log.changeset(%Log{}, attrs))

  def delete_logs(group_id), do: Repo.delete_all(from(l in Log, where: l.group_id == ^group_id))

  # Settings (Group View, does not persist in database)
  def change_settings(attrs \\ %{}), do: Setting.changeset(%Setting{}, attrs)
end
