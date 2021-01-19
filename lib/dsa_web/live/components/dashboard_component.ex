defmodule DsaWeb.DashboardComponent do
  use DsaWeb, :live_component

  alias Dsa.Accounts

  def render(assigns) do
    ~L"""
    <div class="absolute inset-0 lg:grid lg:grid-cols-5 lg:gap-4 p-2 lg:p-3">
      <div class="lg:col-span-3 flex flex-col">
        <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
            <div class="shadow-md overflow-hidden border-b border-gray-200 sm:rounded-lg">
              <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-300">
                  <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Held
                    </th>
                    <th scope="col" class="hidden px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      AP
                    </th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Status
                    </th>
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
                      <td class="hidden px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        1200
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
          </div>
        </div>
      </div>
      <div class="lg:col-span-2">
        <div class="bg-white relative shadow-xl rounded-lg">
          <h1 class="font-bold text-center bg-gray-300 rounded-t-lg leading-10 h-10 text-xl text-gray-900">Benutzerverwaltung</h1>
          <div class="w-full">
            <%= live_patch "Passwort ändern", to: Routes.dsa_path(@socket, :change_password),
            class: "w-full font-medium text-gray-600 py-2 px-4 w-full block hover:bg-gray-100 transition duration-150" %>

            <a href="#" class="w-full border-t-2 border-gray-100 font-medium text-red-700 py-2 px-4 w-full block hover:bg-gray-100 transition duration-150">Account löschen</a>
          </div>
        </div>
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
