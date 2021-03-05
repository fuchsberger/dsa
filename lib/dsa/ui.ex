defmodule Dsa.UI do
  @moduledoc """
  The Event context.
  """

  alias Dsa.UI.{LogSetting, Roll, SkillRoll}

  def change_logsetting(attrs \\ %{}), do: LogSetting.changeset(%LogSetting{}, attrs)

  def change_roll(attrs \\ %{}), do: Roll.changeset(%Roll{}, attrs)

  def change_skill_roll(attrs), do: SkillRoll.changeset(%SkillRoll{}, attrs)
end
