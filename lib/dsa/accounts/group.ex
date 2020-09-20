defmodule Dsa.Accounts.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string

    belongs_to :master, Dsa.Accounts.User

    has_many :characters, Dsa.Accounts.Character
    has_many :logs, Dsa.Event.Log

    timestamps()
  end

  @fields [:name, :master_id]
  def changeset(group, attrs) do
    group
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:name, max: 10)
    |> foreign_key_constraint(:master_id)
  end
end
