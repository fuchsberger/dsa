defmodule Dsa.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating entities via the `Dsa.Accounts` context.
  """
  alias Dsa.Repo
  alias Dsa.Accounts.{User, UserToken}

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def valid_user_username, do: "User"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      username: valid_user_username()
    })
  end

  def user_fixture(attrs \\ %{}, opts \\ []) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: valid_user_username(),
        email: unique_user_email(),
        password: valid_user_password()
      })
      |> Dsa.Accounts.register_user()

    # Confirm user prior to returning
    if Keyword.get(opts, :confirmed, true), do: Repo.transaction(confirm_user_multi(user))

    user
  end

  def extract_user_token(fun) do
    # encapsulated ok should not work but does...
    {:ok, {:ok, captured}} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.text_body, "[TOKEN]")
    token
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
  end
end
