defmodule Dsa.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  alias Dsa.{Accounts, Repo}
  alias Dsa.Accounts.Credential

  require Logger

  def up do
    # prepare credentials
    create table(:credentials) do
      add :email, :string, null: false
      add :password_hash, :string
      add :confirmed, :boolean
      add :reset, :boolean
      add :token, :string, size: 64
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:credentials, :email)
    create index(:credentials, :user_id)

    flush()

    # copy from user to credentials
    users = Accounts.list_users()

    Enum.each(users, fn user ->
      %Credential{
        email: user.email,
        password_hash: user.password_hash,
        confirmed: user.confirmed,
        reset: user.reset,
        token: user.token}
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Repo.insert()
    end)

    # remove from user to credentials
    drop index(:users, :email)

    alter table(:users) do
      remove :confirmed
      remove :reset
      remove :token
      remove :email
      remove :password_hash
    end
  end

  def down do
    # prepare users
    alter table(:users) do
      add :confirmed, :boolean
      add :reset, :boolean
      add :token, :string, size: 64
      add :email, :string
      add :password_hash, :string
    end

    create unique_index(:users, :email)

    flush()

    # copy from credentials to user
    users = Accounts.list_users()

    Enum.each(users, fn user ->
      %{credential: credential} = Repo.preload(user, :credential)

      # To downgrade make sure to add the fields back to user in struct first.
      user
      |> Ecto.Changeset.change(%{
        email: credential.email,
        password_hash: credential.password_hash,
        confirmed: credential.confirmed,
        reset: credential.reset,
        token: credential.token})
      |> Repo.update!()
    end)

    alter table(:users) do
      modify :email, :string, null: false
    end

    drop index(:credentials, :email)
    drop index(:credentials, :user_id)
    drop table(:credentials)
  end
end
