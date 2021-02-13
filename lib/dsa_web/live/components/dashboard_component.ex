defmodule DsaWeb.DashboardComponent do
  use DsaWeb, :live_component

  alias Dsa.Accounts

  def render(assigns) do
    ~L"""
    <div class="shadow-xl overflow-hidden border-b sm:rounded-lg">
      <table class="w-full border-gray-200 divide-y divide-gray-200">
        <thead class="leading-8 text-gray-900 bg-gray-300 font-medium text-left">
          <tr>
            <th scope="col" class="px-6">
              <%= live_patch to: Routes.dsa_path(@socket, :new_character) do %>
                <svg class='inline-block w-5 h-5' fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
              <% end %>
              <span>Held</span>
            </th>
            <th scope="col" class="px-6">Status</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <%= for character <- @characters do %>
            <tr>
              <td class="px-3 py-2 whitespace-nowrap">
                <div class="ml-4">
                  <div class="text-sm font-medium text-gray-900">
                    <%= character.name %>
                  </div>
                  <div class="text-sm text-gray-500">
                    <%= character.profession %>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <button type='button' class="label <%= if character.id == @active_character_id, do: "green", else: "gray" %>" phx-click='activate' phx-target='<%= @myself %>' phx-value-character='<%= character.id %>'>
                  <%= if character.id == @active_character_id, do: "A", else: "Ina" %>ktiv
                </button>
                <button type='button' class='label gray' data-confirm='Bist du sicher?' phx-target='<%= @myself %>' phx-click='delete' phx-value-character='<%= character.id %>'>Entfernen</button>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>

    <div class="bg-white relative shadow-xl rounded-lg mt-4">
      <h1 class="font-bold text-center bg-gray-300 rounded-t-lg leading-10 h-10 text-xl text-gray-900">Benutzerverwaltung</h1>
      <div class="w-full">
        <%= live_patch "Passwort ändern", to: Routes.dsa_path(@socket, :reset_password),
        class: "w-full font-medium text-gray-600 py-2 px-4 w-full block hover:bg-gray-100 transition duration-150" %>

        <a href="#" class="hidden w-full border-t-2 border-gray-100 font-medium text-red-700 py-2 px-4 w-full block hover:bg-gray-100 transition duration-150">Account löschen</a>
      </div>
    </div>
    """
  end

  def update(%{active_character_id: active_character_id, user_id: user_id}, socket) do
    {:ok, socket
    |> assign(:active_character_id, active_character_id)
    |> assign(:characters, Accounts.list_user_characters!(user_id))
    |> assign(:user_id, user_id)}
  end

  def handle_event("activate", %{"character" => id}, socket) do
    id = if String.to_integer(id) == socket.assigns.active_character_id, do: nil, else: id
    user = Accounts.get_user(socket.assigns.user_id)

    case Accounts.update_user(user, %{active_character_id: id}) do
      {:ok, user} ->
        send self(), :update_user
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("An error occured when toggling active character: \n#{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("delete", %{"character" => id}, socket) do
    character = Accounts.get_character!(id)

    case Accounts.delete_character(character) do
      {:ok, character} ->
        send self(), :update_user
        characters = Enum.reject(socket.assigns.characters, & &1.id == character.id)
        {:noreply, assign(socket, :characters, characters)}

      {:error, changeset} ->
        Logger.error("An error occured when deleting character: \n#{inspect(changeset)}")
        {:noreply, socket}
    end
  end
end
