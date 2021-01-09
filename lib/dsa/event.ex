defmodule Dsa.Event do
  @moduledoc """
  The Event context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Accounts.Character
  alias Dsa.Event.{Setting, Log}

  def list_logs(group_id) do
    from(l in Log,
      where: l.group_id == ^group_id,
      preload: [character: ^from(c in Character, select: c.name)],
      order_by: [desc: l.inserted_at]
    ) |> Repo.all()
  end

  def change_log(attrs \\ %{}), do: Log.changeset(%Log{}, attrs)

  def create_log(attrs), do: Repo.insert(Log.changeset(%Log{}, attrs))

  def delete_logs(group_id), do: Repo.delete_all(from(l in Log, where: l.group_id == ^group_id))

  # Settings (Group View, does not persist in database)
  def change_settings(attrs \\ %{}), do: Setting.changeset(%Setting{}, attrs)

  def preload_character_name(struct) do
    Repo.preload(struct, character: from(c in Character, select: c.name))
  end
end
