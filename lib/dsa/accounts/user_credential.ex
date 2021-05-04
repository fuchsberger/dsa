defmodule Dsa.Accounts.UserCredential do
  use Ecto.Schema

  import Ecto.Changeset
  import DsaWeb.Gettext

  @derive {Inspect, except: [:password, :password_confirmation]}
  schema "user_credentials" do
    field :confirmed_at, :naive_datetime
    field :email, :string
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    belongs_to :user, Dsa.Accounts.User
    timestamps()
  end

  @doc """
  A credential changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(credential, attrs, opts \\ []) do
    credential
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_email()
    |> validate_password_confirm()
    |> validate_password(opts)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/,
      message: dgettext("account", "must have the @ sign and no spaces"))
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Dsa.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 80)
    |> validate_format(:password, ~r/[a-z]/,
      message: dgettext("account", "at least one lower case character"))
    # |> validate_format(:password, ~r/[A-Z]/, message: gettext("at least one upper case character"))
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: dgettext("account", "at least one digit or punctuation character"))
    |> maybe_hash_password(opts)
  end

  defp validate_password_confirm(changeset) do
    case get_change(changeset, :password) == get_change(changeset, :password_confirmation) do
      true ->
        changeset
      false ->
        add_error(changeset, :password_confirmation, dgettext("account", "Passwords don't match"))
    end
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, dgettext("account", "did not change"))
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(credential, attrs, opts \\ []) do
    credential
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: dgettext("account", "does not match password"))
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(credential) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(credential, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Dsa.Accounts.UserCredential{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, dgettext("account", "is not valid"))
    end
  end
end
