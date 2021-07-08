defmodule DsaWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use DsaWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import DsaWeb.ConnCase
      import DsaWeb.Gettext

      alias DsaWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint DsaWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Dsa.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Dsa.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Assertation helper that checks whether a flash message contains text.
  """
  def flash_messages_contain(conn, text) do
    conn
    |> Phoenix.Controller.get_flash()
    |> Enum.any?(fn item -> String.contains?(elem(item, 1), text) end)
  end

  @doc """
  Setup helper that registers and logs in users.

      setup :register_and_log_in_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = Dsa.AccountsFixtures.user_fixture()
    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Setup helper that creates an activated character. Requires :register_and_log_in_user

      setup [:register_and_log_in_user, :with_active_character]

  It creates and selects a character.
  """
  def with_active_character(%{conn: conn, user: user}) do
    character  = Dsa.GameFixtures.character_fixture(user)
    {:ok, user} = Dsa.Game.select_character(user, character)
    %{conn: conn, user: user, character: user.active_character}
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    token = Dsa.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end
end
