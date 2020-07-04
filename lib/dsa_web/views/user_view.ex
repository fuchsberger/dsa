defmodule DsaWeb.UserView do
  use DsaWeb, :view

  alias Dsa.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
