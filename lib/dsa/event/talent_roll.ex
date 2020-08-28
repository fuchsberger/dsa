defmodule Dsa.Event.TalentRoll do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

  schema "talent_rolls" do

    field :level, :integer
    field :w1, :integer
    field :w2, :integer
    field :w3, :integer
    field :t1, :integer
    field :t2, :integer
    field :t3, :integer
    field :e1, :string
    field :e2, :string
    field :e3, :string
    field :modifier, :integer, default: 0
    field :be, :integer

    belongs_to :skill, Dsa.Lore.Skill
    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group

    timestamps()
  end

  @fields ~w(skill_id character_id group_id level w1 w2 w3 t1 t2 t3 e1 e2 e3 modifier be)a
  def changeset(roll, attrs) do
    roll
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:e1, base_value_options())
    |> validate_inclusion(:e2, base_value_options())
    |> validate_inclusion(:e3, base_value_options())
    |> validate_number(:t1, greater_than: 5)
    |> validate_number(:t2, greater_than: 5)
    |> validate_number(:t3, greater_than: 5)
    |> validate_number(:modifier, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> validate_number(:be, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:skill_id)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
