defmodule Dsa.UI.LogSetting do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :dice, :boolean, default: true
    field :result, :boolean, default: true
  end

  def changeset(log, attrs) do
    log
    |> cast(attrs, [:dice, :result])
    |> validate_required([:dice, :result])
  end
end
