defmodule Dsa.GameFixtures do
  @moduledoc """
  This module defines test helpers for creating entities via the `Dsa.Accounts` context.
  """
  alias Dsa.Game

  def character_fixture(%Dsa.Accounts.User{} = user, attrs \\ %{}) do
    {:ok, character} =
      Game.create_character(user, Enum.into(attrs, %{
        name: "Ethric",
        profession: "Elementarmagier"
      }))

    character
  end
end
