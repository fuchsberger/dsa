defmodule Dsa.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :username, :string
    field :password_old, :string, virtual: true
    field :password, :string, virtual: true
    field :password_confirm, :string, virtual: true
    field :password_hash, :string
    field :admin, :boolean, default: false

    has_many :characters, Dsa.Accounts.Character

    timestamps()
  end

  # used for admin changes
  def changeset(user, params) do
    user
    |> cast(params, [:admin, :password, :name, :username])
    |> validate_length(:name, min: 2, max: 10)
    |> validate_length(:username, min: 2, max: 15)
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  @fields ~w(password_old password password_confirm)a
  def password_changeset(user, params) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_password(:password_old)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_match(:password, :password_confirm)
    |> put_pass_hash()
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  # @fields ~w(admin name username)a
  # def changeset(user, attrs) do
  #   user
  #   |> cast(attrs, @fields)
  #   |> validate_required(@fields)
  #   |> validate_length(:name, min: 2, max: 10)
  #   |> validate_length(:username, min: 2, max: 15)
  # end

  defp validate_match(changeset, field1, field2) do
    case get_change(changeset, field1) == get_change(changeset, field2) do
      true -> changeset
      false -> add_error(changeset, field2, "Passwords don't match")
    end
  end

  def validate_password(changeset, field) do
    if Map.has_key?(changeset.changes, field) do
      case Pbkdf2.verify_pass(Map.get(changeset.changes, field), changeset.data.password_hash) do
        true ->
          changeset

        false ->
          Pbkdf2.no_user_verify()
          add_error(changeset, field, "Current Password incorrect.")
      end
    else
      changeset
    end
  end
end
