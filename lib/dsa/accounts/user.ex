defmodule Dsa.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  require Logger

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_old, :string, virtual: true
    field :password, :string, virtual: true
    field :new_password, :string, virtual: true
    field :password_confirm, :string, virtual: true
    field :password_hash, :string
    field :admin, :boolean, default: false
    field :confirmed, :boolean, default: false
    field :reset, :boolean, default: false
    field :token, :string

    belongs_to :active_character, Dsa.Accounts.Character
    has_many :characters, Dsa.Accounts.Character

    timestamps()
  end

  # used for registration, change active character, creating tokens
  def changeset(user, params) do
    user
    |> cast(params, [:username, :confirmed, :reset, :token, :active_character_id])
    |> validate_length(:username, min: 2, max: 15)
    |> validate_length(:token, size: 64)
    |> foreign_key_constraint(:active_character_id)
  end

  # used for reset password (part 1) and registration
  def email_changeset(user, params) do
    user
    |> cast(params, [:email])
    |> validate_required([:email])
    |> validate_email(:email)
  end

  def password_changeset(user, params, bypass_security?) do
    user
    |> cast(params, [:password_old, :password, :password_confirm])
    |> validate_required([:password, :password_confirm])
    |> validate_old_password(bypass_security?)
    |> validate_password()
    |> validate_match(:password, :password_confirm)
    |> put_pass_hash()
    |> put_change(:reset, false)
    |> put_change(:token, nil)
  end

  def session_changeset(user, params) do
    user
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> email_changeset(params)
    |> cast(params, [:new_password, :password_confirm])
    |> validate_required([:email, :username, :new_password, :password_confirm])
    |> validate_password(:new_password)
    |> validate_match(:new_password, :password_confirm)
    |> put_pass_hash()
    |> put_token()
    |> unique_constraint(:email)
  end

  def reset_password_changeset(user, params) do
    user
    |> cast(params, [:email])
    |> validate_required([:email])
    |> validate_email(:email)
    |> put_token(true)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{new_password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  def put_token(changeset, reset \\ false) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        token =
          :crypto.strong_rand_bytes(64)
          |> Base.url_encode64
          |> binary_part(0, 64)

        changeset
        |> put_change(:reset, reset)
        |> put_change(:token, token)

      _ ->
        changeset
    end
  end

  defp validate_match(changeset, field1, field2) do
    case get_change(changeset, field1) == get_change(changeset, field2) do
      true -> changeset
      false -> add_error(changeset, field2, "Passwords don't match")
    end
  end

  defp validate_email(changeset, field) do
    regex = ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
    validate_format(changeset, field, regex, message: "Keine gültige Email Adresse.")
  end

  defp validate_password(changeset, field \\ :password) do
    regex = ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^\s-]{8,}$/

    changeset
    |> validate_length(field, max: 255)
    |> validate_format(field, regex, message: "Dein Passwort muss mindestens 8 Zeichen lang sein und muss mindestens einen Großbuchstaben, einen Kleinbuchstaben und eine Ziffer enthalten.")
  end

  def validate_old_password(changeset, bypass_security?) do
    case bypass_security? do
      false ->
        changeset = validate_required(changeset, [:password_old])

        if changeset.valid? do
          case Pbkdf2.verify_pass(Map.get(changeset.changes, :password_old), changeset.data.password_hash) do
            true ->
              changeset

            false ->
              Pbkdf2.no_user_verify()
              add_error(changeset, :password_old, "Current Password incorrect.")
          end
        else
          changeset
        end

      true ->
        changeset
    end
  end
end
