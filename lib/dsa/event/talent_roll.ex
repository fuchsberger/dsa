defmodule Dsa.Event.TalentRoll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "talent_rolls" do
    field :talent, :string
    field :level, :integer
    field :w1, :integer
    field :w2, :integer
    field :w3, :integer
    field :e1, :integer
    field :e2, :integer
    field :e3, :integer
    field :t1, :string
    field :t2, :string
    field :t3, :string
    field :modifier, :integer, default: 0
    field :be, :integer, default: 0
    field :use_be, :boolean, default: false, virtual: true
    field :max_be, :integer, virtual: true
    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group
    timestamps()
  end

  @traits ~w(mu kl in ch ff ge ko kk)
  @required_fields ~w(talent level w1 w2 w3 e1 e2 e3 t1 t2 t3 be use_be max_be modifier character_id group_id)a
  def changeset(roll, attrs) do
    roll
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:t1, @traits)
    |> validate_inclusion(:t2, @traits)
    |> validate_inclusion(:t3, @traits)
    |> validate_number(:w1, greater_than_or_equal_to: 1, less_than_or_equal_to: 20)
    |> validate_number(:w2, greater_than_or_equal_to: 1, less_than_or_equal_to: 20)
    |> validate_number(:w3, greater_than_or_equal_to: 1, less_than_or_equal_to: 20)
    |> validate_number(:e1, greater_than: 0)
    |> validate_number(:e2, greater_than: 0)
    |> validate_number(:e3, greater_than: 0)
    |> validate_number(:max_be, greater_than_or_equal_to: 0)
    |> validate_number(:modifier, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> put_be()
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end

  defp put_be(changeset) do
    if get_change(changeset, :use_be),
      do: put_change(changeset, :be, get_change(changeset, :max_be)),
      else: changeset
  end
end
