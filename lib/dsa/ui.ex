defmodule Dsa.UI do
  @moduledoc """
  The Event context.
  """

  alias Dsa.UI.LogSetting

  def change_logsetting(attrs \\ %{}), do: LogSetting.changeset(%LogSetting{}, attrs)
end
