defmodule Dsa.Game.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    has_many :characters, Dsa.Game.Character
    has_many :logs, Dsa.Game.Log
    belongs_to :master, Dsa.Accounts.User
    timestamps()
  end

  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :master_id])
    |> validate_required([:name, :master_id])
    |> foreign_key_constraint(:master_id)
  end
end
