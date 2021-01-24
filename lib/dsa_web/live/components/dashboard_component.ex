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
          <%= for character <- @user.characters do %>
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
                <button type='button' class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full focus:outline-none <%= if character.id == @user.active_character_id, do: "bg-green-100 text-green-800 hover:bg-green-200", else: "bg-gray-50 text-gray-500 hover:bg-gray-200" %>" phx-click='activate' phx-target='<%= @myself %>' phx-value-character='<%= character.id %>'>
                  <%= if character.id == @user.active_character_id, do: "A", else: "Ina" %>ktiv
                </button>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>



    <div class="hidden bg-white relative shadow-xl rounded-lg mt-4">
      <h1 class="font-bold text-center bg-gray-300 rounded-t-lg leading-10 h-10 text-xl text-gray-900">Benutzerverwaltung</h1>
      <div class="w-full">
        <%= live_patch "Passwort ändern", to: Routes.dsa_path(@socket, :change_password),
        class: "w-full font-medium text-gray-600 py-2 px-4 w-full block hover:bg-gray-100 transition duration-150" %>

        <a href="#" class="w-full border-t-2 border-gray-100 font-medium text-red-700 py-2 px-4 w-full block hover:bg-gray-100 transition duration-150">Account löschen</a>
      </div>
    </div>


    """
  end

  def handle_event("activate", %{"character" => id}, socket) do
    id = if String.to_integer(id) == socket.assigns.user.active_character_id, do: nil, else: id

    case Accounts.update_user(socket.assigns.user, %{active_character_id: id}) do
      {:ok, user} ->
        send self(), {:update_user, Accounts.preload_user(user)}
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("An error occured when toggling active character: \n#{inspect(changeset)}")
        {:noreply, socket}
    end
  end
end
