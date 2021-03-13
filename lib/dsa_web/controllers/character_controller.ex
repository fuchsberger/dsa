defmodule DsaWeb.CharacterController do
  @moduledoc """
  Handles all actions related to a user's character.
  """
  use DsaWeb, :controller

  alias Dsa.Accounts
  alias Dsa.Characters

  plug :assign_character when action in [:edit, :update, :delete, :activate, :toggle_visible]

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  @doc """
  Lists all characters that belong to current user (dashboard).
  """
  def index(conn, _params, current_user) do
    conn
    |> assign(:characters, Characters.list(current_user))
    |> render("index.html")
  end

  @doc """
  TODO: Create a publically accessible overview page of your character.
  TODO: Right now the option whether the character is shown to the public is determined by it's
  visible flag. In the future visible should be separated from public because game masters may not
  necessarily want to share NPC's stats with the players or the public.
  """
  def show(conn, %{"id" => id}, current_user) do
    case Accounts.get_character!(id) do
      nil ->
        conn
        |> put_flash(:info, gettext("Character does not exist."))
        |> redirect(to: Routes.session_path(conn, :index))

      character ->
        user_character_ids = Enum.map(current_user.characters, fn {id, _name} -> id end)
        if character.visible || Enum.member?(user_character_ids, character.id) do
          conn
          |> assign(:character, character)
          |> render("show.html")
        else
          conn
          |> put_flash(:info, gettext("This character is hidden by the user."))
          |> redirect(to: Routes.session_path(conn, :index))
        end
    end
  end

  def new(conn, _params, _current_user) do
    conn
    |> assign(:changeset, Characters.change())
    |> render("new.html")
  end

  def create(conn, %{"character" => character_params}, current_user) do
    case Characters.create(current_user, character_params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, gettext("Character created successfully."))
        |> redirect(to: Routes.character_path(conn, :edit, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => _id}, _current_user) do
    conn
    |> assign(:changeset, Characters.change(conn.assigns.character))
    |> render("edit.html")
  end

  def update(conn, %{"id" => _id, "character" => params}, _current_user) do
    case Characters.update(conn.assigns.character, params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, gettext("Character updated successfully."))
        |> redirect(to: Routes.character_path(conn, :edit, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => _id}, _current_user) do
    {:ok, _character} = Characters.delete(conn.assigns.character)

    conn
    |> put_flash(:info, gettext("Character deleted successfully."))
    |> redirect(to: Routes.character_path(conn, :index))
  end

  def activate(conn, %{"id" => _id}, current_user) do
    case Characters.activate(current_user, conn.assigns.character) do
      {:ok, _user} ->
        redirect(conn, to: Routes.character_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("Error updating user: \n#{inspect(changeset.errors)}")

        conn
        |> put_flash(:info, gettext("An error occured when updating user."))
        |> redirect(to: Routes.character_path(conn, :index))
    end
  end

  def toggle_visible(conn, %{"id" => _id}, _current_user) do
    params = %{visible: !conn.assigns.character.visible}
    case Characters.update(conn.assigns.character, params) do
      {:ok, _character} ->
        redirect(conn, to: Routes.character_path(conn, :index))

      {:error, changeset} ->
        Logger.error("Error updating character: \n#{inspect(changeset.errors)}")

        conn
        |> put_flash(:info, gettext("An error occured when updating character."))
        |> redirect(to: Routes.character_path(conn, :index))
    end
  end

  defp assign_character(conn, _opts) do
    character = Characters.get!(conn.assigns.current_user, conn.params["id"])
    assign(conn, :character, character)
  end
end
