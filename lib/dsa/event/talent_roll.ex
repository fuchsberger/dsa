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
    field :use_be, :boolean, virtual: true
    field :be, :integer, default: false

    belongs_to :skill, Dsa.Lore.Skill
    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group

    timestamps()
  end

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, [:skill_id, :use_be, :t1, :t2, :t3, :e1, :e2, :e3, :modifier])
    |> validate_required([:skill_id, :use_be, :t1, :t2, :t3, :e1, :e2, :e3, :modifier])
    |> validate_inclusion(:e1, base_value_options())
    |> validate_inclusion(:e2, base_value_options())
    |> validate_inclusion(:e3, base_value_options())
    |> validate_number(:t1, greater_than: 5)
    |> validate_number(:t2, greater_than: 5)
    |> validate_number(:t3, greater_than: 5)
    |> validate_number(:modifier, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> foreign_key_constraint(:skill_id)
  end

  def changeset(roll, attrs, :create) do
    roll
    |> changeset(attrs)
    |> cast(attrs, [:level, :w1, :w2, :w3, :be, :group_id, :character_id])
    |> validate_required([:level, :w1, :w2, :w3, :be, :group_id, :character_id])
    |> validate_number(:w1, greater_than_or_equal_to: 1, less_than_or_equal_to: 20)
    |> validate_number(:w2, greater_than_or_equal_to: 1, less_than_or_equal_to: 20)
    |> validate_number(:w3, greater_than_or_equal_to: 1, less_than_or_equal_to: 20)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
