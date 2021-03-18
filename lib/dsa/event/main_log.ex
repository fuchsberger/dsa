defmodule Dsa.Event.MainLog do
  use Ecto.Schema
  use EnumType
  import Ecto.Changeset

  defenum Type, :integer do
    value NotSpecified, -1
    value SimpleText, 0
    value QuickRoll, 1
    value BaseRoll, 2
    value CustomTalentRoll, 3
    value SkillRoll, 4
    value SpellRoll, 5

    default NotSpecified
  end

  defenum ResultType, :integer do
    value Neutral, 0
    value Success, 1
    value Failure, 2

    default Neutral
  end

  schema "main_log" do
    field :type, Type, default: Type.NotSpecified
    field :result_type, ResultType, default: ResultType.Neutral
    field :character_name, :string
    field :left, :string
    field :right, :string
    field :result, :string
    field :roll, :integer

    belongs_to :character, Dsa.Characters.Character
    belongs_to :group, Dsa.Accounts.Group

    timestamps()
  end

  def changeset(log, attrs) do
    log
    |> cast(attrs, [:type, :roll, :character_name, :left, :right, :result, :result_type, :group_id, :character_id])
    |> validate_required([:type, :group_id, :left, :right])
  end
end
