defmodule Dsa.Event.Log do
  use Ecto.Schema
  use EnumType
  import Ecto.Changeset

  defenum Type, :integer do
    value SimpleText, 0
    value QuickRoll, 1
    value BaseRoll, 2
    value CustomTalentRoll, 3
    value SkillRoll, 4
    value SpellRoll, 5

    default NotSpecified
  end

  schema "logs" do
    field :data, :map
    field :type, Type, default: NotSpecified
    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group
    timestamps()
  end

  @fields ~w(data type character_id group_id)a
  def changeset(log, attrs) do
    log
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
