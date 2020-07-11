defmodule Dsa.Game.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :message, :string
    field :details, :string
    belongs_to :character, Dsa.Game.Character
    belongs_to :group, Dsa.Game.Group
    timestamps()
  end

  def changeset(log, attrs) do
    log
    |> cast(attrs, [:message, :details, :character_id, :group_id])
    |> validate_required([:message, :group_id])
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
