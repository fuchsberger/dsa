defmodule DsaWeb.CharacterLive do

  use Phoenix.LiveView

  alias Dsa.Game

  def render(assigns), do: DsaWeb.CharacterView.render("show.html", assigns)

  def mount(params, %{"user_id" => user_id} = session, socket) do
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
    |> assign(:character, character)
    |> assign(:tab, "Übersicht")}
  end

  def handle_event("tab", %{"id" => tab}, socket) do
    {:noreply, assign(socket, :tab, tab)}
  end

  def handle_event("validate", %{"character" => params}, socket) do
    changeset = Game.change_character(socket.assigns.character, params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("update", %{"character" => params}, socket) do
    case Game.update_character(socket.assigns.changeset.data, params) do
      {:ok, character} ->
        {:noreply, socket
        |> assign(:changeset, Game.change_character(character))
        |> assign(:character, character)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
