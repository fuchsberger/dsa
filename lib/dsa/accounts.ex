defmodule Dsa.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Accounts.{UserCredential, Group, User, UserToken, UserNotifier}

  ## Database getters

  @doc """
  Gets a credential by user_id.

  ## Examples

      iex> get_credential(1)
      %User{}

      iex> get_credential(-1)
      nil

  """
  def get_credential(id) when is_integer(id) do
    Repo.get(UserCredential, id)
  end

  @doc """
  Gets a credential by email.

  ## Examples

      iex> get_credential_by_email("foo@example.com")
      %User{}

      iex> get_credential_by_email("unknown@example.com")
      nil

  """
  def get_credential_by_email(email) when is_binary(email) do
    Repo.get_by(UserCredential, email: email)
  end

  @doc """
  Gets a credential by email and password.

  ## Examples

      iex> get_credential_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_credential_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_credential_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    credential = Repo.get_by(UserCredential, email: email)
    if UserCredential.valid_password?(credential, password) do
      credential
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  @doc """
  Registers a user by creating a user and an associated credential.
  Returns the credential.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %Credential{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %UserCredential{}
    |> UserCredential.registration_changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:user, with: &User.changeset/2)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(credential)
      %Ecto.Changeset{data: %Credential{}}

  """
  def change_user_registration(%UserCredential{} = credential, attrs \\ %{}) do
    credential
    |> UserCredential.registration_changeset(attrs, hash_password: false)
    |> Ecto.Changeset.cast_assoc(:user, with: &User.changeset/2)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %Credential{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    user
    |> Repo.preload(:credential)
    |> Map.get(:credential)
    |> UserCredential.email_changeset(attrs)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    user
    |> Repo.preload(:credential)
    |> Map.get(:credential)
    |> UserCredential.email_changeset(attrs)
    |> UserCredential.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset = user |> User.email_changeset(%{email: email}) |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user.id, [context]))
  end

  @doc """
  Delivers the update email instructions to the given user.

  ## Examples

      iex> deliver_update_email_instructions(user, current_email, &Routes.user_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(credential)
      %Ecto.Changeset{data: %Credential{}}

  """
  def change_user_password(credential, attrs \\ %{}) do
    UserCredential.password_changeset(credential, attrs, hash_password: false)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(credential, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(credential, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(credential, password, attrs) do
    changeset =
      credential
      |> UserCredential.password_changeset(attrs)
      |> UserCredential.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:credential, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(credential.user_id, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(credential) do
    {token, user_token} = UserToken.build_session_token(credential)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query) |> Repo.preload(:characters)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc """
  Delivers the confirmation email instructions to the given user.

  ## Examples

      iex> deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :confirm, &1))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &Routes.user_confirmation_url(conn, :confirm, &1))
      {:error, :already_confirmed}

  """
  def deliver_user_confirmation_instructions(%UserCredential{} = credential, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do

    if credential.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(credential, "confirm")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(
        credential,
        confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user.credential)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(credential) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:credential, UserCredential.confirm_changeset(credential))
    |> Ecto.Multi.delete_all(:tokens,
        UserToken.user_and_contexts_query(credential.user_id, ["confirm"]))
  end

  ## Reset password

  @doc """
  Delivers the reset password email to the given user.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &Routes.user_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    user = Repo.preload(user, :credential)
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_user_password(user, attrs) do
    user = Repo.preload(user, :credential)
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, UserCredential.password_changeset(user.credential, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user.id, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def list_groups do
    from(g in Group, preload: [
      master: ^from(u in User, select: u.username),
      users: ^from(u in User, select: u.id)
    ])
    |> Repo.all()
  end

  def get_group!(id), do: Repo.get!(Group, id)

  def change_group(%Group{} = group, attrs \\ %{}), do: Group.changeset(group, attrs)

  def create_group(%User{} = user, attrs) do
    %Group{}
    |> Group.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:master, user)
    |> Repo.insert()
  end

  def delete_group(%Group{} = group), do: Repo.delete(group)

  def join_group(%User{} = user, %Group{} = group) do
    user
    |> Repo.preload(:group)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:group, group)
    |> Repo.update()
  end

  def leave_group(%User{} = user) do
    user
    |> Repo.preload(:group)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:group, nil)
    |> Repo.update()
  end
end
