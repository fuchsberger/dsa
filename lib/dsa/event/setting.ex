defmodule Dsa.Event.Setting do

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :action, :string, default: "Kampf"
    field :character_id, :integer
  end

  def changeset(settings, attrs) do
    settings
    |> cast(attrs, [:action, :character_id])
    |> validate_required([:character_id])
    |> validate_inclusion(:action, ["Kampf", "Probe"])
  end
end
