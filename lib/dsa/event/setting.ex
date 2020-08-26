defmodule Dsa.Event.Setting do

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :action, :string, default: "Probe"
    field :character_id, :integer
    field :type, :string, default: "Eigenschaft"
    field :dice_count, :integer, default: 3
    field :dice_type, :integer, default: 20
  end

  @fields ~w(action character_id type dice_count dice_type)a

  def changeset(settings, attrs) do
    settings
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:action, ["Kampf", "Probe"])
    |> validate_inclusion(:type, ["Eigenschaft", "Körper", "Natur", "Gesellschaft", "Wissen", "Handwerk"])
  end
end
