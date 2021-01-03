defmodule Dsa.Event.Log do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(type x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12)a

  schema "logs" do

    Enum.each(@fields, & field(&1, :integer))

    belongs_to :character, Dsa.Accounts.Character
    belongs_to :group, Dsa.Accounts.Group

    timestamps()
  end

  def changeset(log, attrs) do
    log
    |> cast(attrs, @fields ++ [:character_id, :group_id])
    |> validate_required([:type, :character_id, :group_id])
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:group_id)
  end
end
