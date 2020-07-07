defmodule DsaWeb.CharacterLive do

  use Phoenix.LiveView

  alias Dsa.{Accounts, Game}

  def render(assigns), do: DsaWeb.GameView.render("character.html", assigns)

  def mount(params, %{"user_id" => user_id}, socket) do
    character =
      case Map.get(params, "character_id") do
        nil ->
          %Game.Character{}

        character_id ->
          case Game.get_user_character!(user_id, character_id) do
            nil -> %Game.Character{}
            character -> character
          end
      end

    {:ok, socket
    |> assign(:changeset, Game.change_character(character))
    |> assign(:tab, "Körper")
    |> assign(:user_id, user_id)}
  end

  def handle_event("tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :tab, tab)}
  end

  def handle_event("validate", %{"character" => params}, socket) do
    changeset = Game.change_character(socket.assigns.changeset.data, params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("create", %{"character" => params}, socket) do
    user = Accounts.get_user(socket.assigns.user_id, false)

    case Game.create_character(user, params) do
      {:ok, character} ->
        {:noreply, socket
        |> assign(:changeset, Game.change_character(character))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("update", %{"character" => params}, socket) do
    case Game.update_character(socket.assigns.changeset.data, params) do
      {:ok, character} ->
        character = Game.get_character!(character.id)
        {:noreply, socket
        |> assign(:changeset, Game.change_character(character))
        |> assign(:character, character)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
