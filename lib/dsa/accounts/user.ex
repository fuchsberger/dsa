defmodule Dsa.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset
  import DsaWeb.Gettext #TODO: Change Validation Error Domain for messages

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_hash, :string
    field :admin, :boolean, default: false
    field :confirmed, :boolean, default: false
    field :reset, :boolean, default: false
    field :token, :string

    # virtual fields
    field :password_old, :string, virtual: true
    field :password, :string, virtual: true
    field :password_confirm, :string, virtual: true

    belongs_to :group, Dsa.Accounts.Group, on_replace: :nilify
    belongs_to :active_character, Dsa.Characters.Character, on_replace: :nilify
    has_many :characters, Dsa.Characters.Character

    timestamps()
  end

  # used for non-sensitive changes by user
  def changeset(user, params) do
    user
    |> cast(params, [:username, :group_id])
    |> validate_required([:username])
    |> validate_length(:username, min: 2, max: 15)
    |> foreign_key_constraint(:group_id)
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> email_changeset(params)
    |> password_changeset(params)
    |> put_pass_hash()
    |> put_token()
  end

  # used to reset tokens (should never be handled via web form)
  def manage_changeset(user, params) do
    user
    |> cast(params, [:confirmed, :reset, :token, :admin])
  end

  # used for reset password (part 1) and registration
  def email_changeset(user, params) do
    user
    |> cast(params, [:email])
    |> validate_required([:email])
    |> validate_email(:email)
    |> unique_constraint(:email)
  end

  # used for reset password (part 2) and registration
  def password_changeset(user, params) do
    user
    |> cast(params, [:password, :password_confirm])
    |> validate_required([:password, :password_confirm])
    |> validate_password()
    |> validate_match(:password, :password_confirm)
    |> put_pass_hash()
    |> put_change(:reset, false)
    |> put_change(:token, nil)
  end

  def reset_password_changeset(user, params) do
    user
    |> cast(params, [:email])
    |> validate_required([:email])
    |> validate_email(:email)
    |> put_token()
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
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :token, token())

      _ ->
        changeset
    end
  end

  def token do
    :crypto.strong_rand_bytes(64)
    |> Base.url_encode64
    |> binary_part(0, 64)
  end

  defp validate_match(changeset, field1, field2) do
    case get_change(changeset, field1) == get_change(changeset, field2) do
      true -> changeset
      false -> add_error(changeset, field2, gettext("Passwords don't match"))
    end
  end

  defp validate_email(changeset, field) do
    regex = ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
    validate_format(changeset, field, regex, message: gettext("Invalid email address."))
  end

  defp validate_password(changeset, field \\ :password) do
    regex = ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^\s-]{1,}$/

    changeset
    |> validate_length(field, min: 8, max: 255)
    |> validate_format(field, regex, message: gettext("must contain one upper-case, one lower-case letter and one digit"))
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
              add_error(changeset, :password_old, gettext("Current Password incorrect."))
          end
        else
          changeset
        end

      true ->
        changeset
    end
  end
end
