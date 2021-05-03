defmodule Dsa.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset
  import DsaWeb.Gettext

  schema "users" do
    field :admin, :boolean, default: false
    field :username, :string

    has_one :credential, Dsa.Accounts.UserCredential
    has_many :characters, Dsa.Characters.Character
    belongs_to :group, Dsa.Accounts.Group, on_replace: :nilify

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_username()
  end

  defp validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_length(:username, min: 2, max: 15)
  end
end
