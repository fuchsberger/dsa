defmodule Dsa.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dsa.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def valid_username, do: "Der Namenlose"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      password_confirmation: valid_user_password(),
      user: %{username: valid_username()}
    })
  end

  def user_credential_fixture(attrs \\ %{}) do
    {:ok, credential} =
      attrs
      |> valid_user_attributes()
      |> Dsa.Accounts.register_user()
    credential
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
