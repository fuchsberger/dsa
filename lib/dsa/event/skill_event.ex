defmodule Dsa.Event.SkillEvent do
  use Ecto.Schema

  import Ecto.Changeset

  schema "skill_events" do
    field :skill_id, :integer
    field :modifier, :integer, default: 0

    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group
    timestamps()
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, @fields ++ [:character_id, :group_id, :data, :type])
    |> validate_required([:type, :character_id, :group_id])
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
