defmodule Dsa.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Repo, only: [validate_email: 2]

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_old, :string, virtual: true
    field :password, :string, virtual: true
    field :password_confirm, :string, virtual: true
    field :password_hash, :string
    field :admin, :boolean, default: false
    field :confirmed, :boolean, default: false
    field :reset, :boolean, default: false
    field :token, :string

    belongs_to :group, Dsa.Accounts.Group
    belongs_to :active_character, Dsa.Accounts.Character
    has_many :characters, Dsa.Accounts.Character

    timestamps()
  end

  def changeset(user, params) do
    user
    |> cast(params, [:admin, :email, :username, :active_character_id, :group_id])
    |> validate_email(:email)
    |> validate_length(:username, min: 2, max: 15)
    |> unique_constraint(:email)
    |> foreign_key_constraint(:active_character_id)
    |> foreign_key_constraint(:group_id)
  end

  def password_changeset(user, params, validate?) do
    user
    |> cast(params, [:password_old, :password, :password_confirm])
    |> validate_required([:password_old, :password, :password_confirm])
    |> validate_old_password(validate?)
    |> validate_password()
    |> validate_match(:password, :password_confirm)
    |> put_pass_hash()
  end

  def session_changeset(user, params) do
    user
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password, :password_confirm])
    |> validate_password()
    |> validate_match(:password, :password_confirm)
    |> put_pass_hash()
    |> put_token()
  end

  def reset_password_changeset(user, params) do
    user
    |> cast(params, [:email])
    |> validate_required([:email])
    |> validate_email(:email)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  def put_token(changeset) do
    token =
      :crypto.strong_rand_bytes(64)
      |> Base.url_encode64
      |> binary_part(0, 64)

    put_change(changeset, :token, token)
  end

  defp validate_match(changeset, field1, field2) do
    case get_change(changeset, field1) == get_change(changeset, field2) do
      true -> changeset
      false -> add_error(changeset, field2, "Passwords don't match")
    end
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 255)
    |> PasswordValidator.validate(:password, lower_case: 1, numbers: 1, special: 1)
  end

  def validate_old_password(changeset, validate?) do
    case validate? do
      true ->
        if Map.has_key?(changeset.changes, :password_old) do
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

      false ->
        changeset
    end
  end
end
