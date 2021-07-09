defmodule DsaWeb.CharacterController do
  @moduledoc """
  Handles all actions related to a user's character.
  """
  use DsaWeb, :controller

  alias Dsa.Game
  alias Dsa.Game.Character

  action_fallback DsaWeb.ErrorController

  # plug :assign_character when action in [:edit, :update, :delete, :activate, :toggle_visible]

  defp action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  @doc """
  Lists all characters that belong to current user (dashboard).
  """
  def index(conn, _params, current_user) do
    inactive_characters = Game.list_inactive_characters(current_user)
    changeset = Game.change_character(%Character{})
    render(conn, "index.html", changeset: changeset, inactive_characters: inactive_characters)
  end

  # @doc """
  # TODO: Create a publically accessible overview page of your character.
  # TODO: Right now the option whether the character is shown to the public is determined by it's
  # visible flag. In the future visible should be separated from public because game masters may not
  # necessarily want to share NPC's stats with the players or the public.
  # """
  # def show(conn, %{"id" => id}, current_user) do
  #   case Characters.get!(id) do
  #     nil ->
  #       conn
  #       |> put_flash(:info, gettext("Character does not exist."))
  #       |> redirect(to: Routes.session_path(conn, :index))

  #     character ->
  #       user_character_ids = Enum.map(current_user.characters, fn {id, _name} -> id end)
  #       if character.visible || Enum.member?(user_character_ids, character.id) do
  #         conn
  #         |> assign(:character, character)
  #         |> render("show.html")
  #       else
  #         conn
  #         |> put_flash(:info, gettext("This character is hidden by the user."))
  #         |> redirect(to: Routes.session_path(conn, :index))
  #       end
  #   end
  # end

  @doc """
  Creates a new, activated character.
  If no character is currently activated, it will also activate it.
  """
  def create(conn, %{"character" => character_params}, current_user) do
    case Game.create_character(current_user, character_params) do
      {:ok, character} ->
        if is_nil(current_user.active_character_id) do
          Game.select_character(current_user, character)

          conn
          |> put_flash(:info, gettext("Held erfolgreich erstellt und aktiviert."))
          |> redirect(to: Routes.character_path(conn, :index))
        else
          conn
          |> put_flash(:info, gettext("Held erfolgreich erstellt."))
          |> redirect(to: Routes.character_path(conn, :index))
        end


      {:error, %Ecto.Changeset{} = changeset} ->
        inactive_characters = Game.list_inactive_characters(current_user)
        render(conn, "index.html", changeset: changeset, inactive_characters: inactive_characters)
    end
  end

  # def edit(conn, %{"id" => _id}, _current_user) do
  #   conn
  #   |> assign(:changeset, Characters.change(conn.assigns.character))
  #   |> render("edit.html")
  # end

  # def update(conn, %{"id" => _id, "character" => params}, _current_user) do
  #   case Characters.update(conn.assigns.character, params) do
  #     {:ok, character} ->
  #       conn
  #       |> put_flash(:info, gettext("Character updated successfully."))
  #       |> redirect(to: Routes.character_path(conn, :edit, character))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       conn
  #       |> assign(:changeset, changeset)
  #       |> render("edit.html")
  #   end
  # end

  @doc """
  Deletes a character from the Game.
  Should it be active character will automatically select another active character
  to be the active one.
  """
  def delete(conn, %{"id" => id}, current_user) do
    with {:ok, character} <- Game.fetch_character(id),
          :ok <- owned_character?(current_user, character),
         {:ok, _character} = Game.delete_character(character)
    do
      next_character =
        current_user.characters
        |> Enum.reject(&(&1.id == character.id))
        |> List.first()

      unless is_nil(next_character) do
        character = next_character |> Map.get(:id) |> Game.get_character!()
        Game.select_character(current_user, character)
      end

      conn
      |> put_flash(:info, gettext("Held erfolgreich gelöscht."))
      |> redirect(to: Routes.character_path(conn, :index))
    end
  end

  defp owned_character?(user, character) do
    if user.id == character.user_id, do: :ok, else: {:error, :forbidden}
  end

  @doc """
  Activates / enables a character.
  If the no character is currently selected, the activated character will be selected.
  """
  def activate(conn, %{"id" => id}, current_user) do
    with {:ok, character} <- Game.fetch_character(id),
          :ok <- owned_character?(current_user, character),
         {:ok, character} = Game.toggle_character(character, true)
    do
      if is_nil(current_user.active_character_id) do
        Game.select_character(current_user, character)
      end
      redirect(conn, to: Routes.character_path(conn, :index))
    end
  end

  @doc """
  Deactivates / archives a character.
  If the deactivated character is the selected character, another active character will be
  selected. If no other active character is available, simply unselects currenct character.
  """
  def deactivate(conn, %{"id" => id}, current_user) do
    with {:ok, character} <- Game.fetch_character(id),
          :ok <- owned_character?(current_user, character),
         {:ok, character} = Game.toggle_character(character, false)
    do

      if current_user.active_character_id == character.id do
        next_character =
          current_user.characters
          |> Enum.reject(&(&1.id == character.id))
          |> List.first()

        case next_character do
          nil ->
            Game.deselect_character(current_user, character)

          %{id: id} ->
            {:ok, next_character} = Game.fetch_character(id)
            Game.select_character(current_user, next_character)
        end
      end

      redirect(conn, to: Routes.character_path(conn, :index))
    end
  end

  @doc """
  Selects a character, if it belongs to the user.
  """
  def select(conn, %{"id" => id}, current_user) do
    with {:ok, character} <- Game.fetch_character(id),
          :ok <- owned_character?(current_user, character),
         {:ok, character} = Game.toggle_character(character, true)
    do
      Game.select_character(current_user, character)
      redirect(conn, to: Routes.character_path(conn, :index))
    end
  end


  # def toggle_visible(conn, %{"id" => _id}, _current_user) do
  #   params = %{visible: !conn.assigns.character.visible}
  #   case Characters.update(conn.assigns.character, params) do
  #     {:ok, _character} ->
  #       redirect(conn, to: Routes.character_path(conn, :index))

  #     {:error, changeset} ->
  #       Logger.error("Error updating character: \n#{inspect(changeset.errors)}")

  #       conn
  #       |> put_flash(:info, gettext("An error occured when updating character."))
  #       |> redirect(to: Routes.character_path(conn, :index))
  #   end
  # end

  # defp assign_character(conn, _opts) do
  #   character = Characters.get!(conn.assigns.current_user, conn.params["id"])
  #   assign(conn, :character, character)
  # end
end
