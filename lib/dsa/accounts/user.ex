defmodule Dsa.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :admin, :boolean, default: false
    field :username, :string

    has_one :credential, Dsa.Accounts.Credential
    belongs_to :group, Dsa.Accounts.Group, on_replace: :nilify
    belongs_to :active_character, Dsa.Characters.Character, on_replace: :nilify
    has_many :characters, Dsa.Characters.Character

    timestamps()
  end

  # used for non-sensitive changes by user
  def changeset(user, params) do
    user
    |> cast(params, [:username, :group_id])
    |> validate_required([:username])
    |> validate_length(:username, min: 2, max: 15)
    |> foreign_key_constraint(:group_id)
  end
end
