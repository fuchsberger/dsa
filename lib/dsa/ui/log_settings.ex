defmodule Dsa.UI.LogSetting do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :dice, :boolean
    field :limit, :integer
  end

  @fields ~w(dice limit)a
  def changeset(log, attrs) do
    log
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
