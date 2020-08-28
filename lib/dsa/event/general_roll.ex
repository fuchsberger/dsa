defmodule Dsa.Event.GeneralRoll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "general_rolls" do
    field :d1, :integer
    field :d2, :integer
    field :d3, :integer
    field :d4, :integer
    field :d5, :integer
    field :max, :integer
    field :hidden, :boolean
    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group
    timestamps()
  end

  @fields ~w(d1 d2 d3 d4 d5 hidden max character_id group_id)a

  def changeset(roll, attrs) do
    roll
    |> cast(attrs, @fields)
    |> validate_required(~w(d1 max hidden character_id group_id)a)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
