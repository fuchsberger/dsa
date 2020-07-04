defmodule Dsa.Accounts.User do
  use Ecto.Schema
  # import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :username, :string
  end

end
