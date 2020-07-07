defmodule Dsa.Game.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string, required: true
    has_many :characters, Dsa.Game.Character
    belongs_to :master, Dsa.Accounts
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :master_id])
    |> validate_required([:name])
    |> foreign_key_constraint(:master)
  end
end
