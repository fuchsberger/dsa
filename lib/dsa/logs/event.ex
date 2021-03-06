defmodule Dsa.Logs.Event do
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
    value INIRoll, 6
    value ATRoll, 7
    value PARoll, 8
    value DMGRoll, 9
    value BlessingRoll, 10
    value DiceTableRoll, 11

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

  @fields ~w(type roll left right character_name character_id group_id result_type result)a
  def changeset(log, attrs) do
    log
    |> cast(attrs, @fields)
    |> validate_required([:group_id])
    |> Type.validate(:type)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
