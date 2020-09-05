defmodule DsaWeb.CharacterLive do
  use Phoenix.LiveView
  require Logger

  alias Dsa.{Accounts, Lore}
  alias DsaWeb.Router.Helpers, as: Routes

  def render(assigns), do: DsaWeb.CharacterView.render("character.html", assigns)

  def mount(_params, %{"user_id" => user_id}, socket) do
    {:ok, socket
    |> assign(:category, 6)
    |> assign(:group_options, Accounts.list_group_options())
    |> assign(:cast_options, Lore.list_cast_options())
    |> assign(:user_id, user_id)}
  end

  def handle_params(params, _session, socket) do
    user_id = socket.assigns.user_id

    case socket.assigns.live_action do
      :index ->
        {:noreply, assign(socket, :characters, Accounts.list_user_characters(user_id))}

      :new ->
        {:noreply, assign(socket, :changeset, Accounts.change_character(%Accounts.Character{}))}

      :edit ->
        case Accounts.get_user_character!(user_id, Map.get(params, "character_id")) do
          nil ->
            {:noreply, push_redirect(socket, to: Routes.character_path(socket, :index))}

          character ->
            {:noreply, assign(socket, :changeset, Accounts.change_character(character))}
        end
    end
  end

  def handle_event("select", %{"category" => category}, socket) do
    category = if category == "0", do: nil, else: String.to_integer(category)
    {:noreply, assign(socket, :category, category)}
  end

  def handle_event("change", %{"character" => params}, socket) do


    {:noreply, socket}
  end
end
