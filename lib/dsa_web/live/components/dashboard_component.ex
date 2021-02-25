defmodule DsaWeb.DashboardComponent do
  use DsaWeb, :live_component

  alias Dsa.Accounts

  def render(assigns) do
    ~L"""
    <div class="shadow-xl overflow-hidden border-b sm:rounded-lg">
      <table class="w-full border-gray-200 divide-y divide-gray-200">
        <thead class="leading-8 text-gray-900 bg-gray-300 font-medium text-left">
          <tr>
            <th scope="col" class="px-6">Held</th>
            <th scope="col" class='text-center'><%= icon @socket, "eye-solid" %></th>
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
              <td class='text-center'>
                <button
                  class='text-indigo-400'
                  phx-click='update-character'
                  phx-value-id='<%= character.id %>'
                  phx-value-visible='<%= not character.visible %>'
                  phx-target='<%= @myself %>'>
                  <%= icon @socket, (if character.visible, do: "eye", else: "eye-off") %>
                </button>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <button type='button' class="label <%= if character.id == @user.active_character_id, do: "green", else: "gray" %>" phx-click='activate' phx-target='<%= @myself %>' phx-value-character='<%= character.id %>'>
                  <%= if character.id == @user.active_character_id, do: "A", else: "Ina" %>ktiv
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
        <%= f = form_for @user_changeset, "#", phx_change: :change, phx_target: @myself, phx_submit: :update %>
          <div class="grid grid-cols-1 md:grid-cols-5">
            <div class='col-span-2 p-2'>
              <%= label f, :username, "Username", class: "text-sm font-medium text-gray-700" %>
              <%= text_input f, :username, class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" %>
              <%= error_tag f, :username %>
            </div>
            <div class='col-span-2 p-2'>
              <%= label f, :group_id, "Gruppe", class: "text-sm font-medium text-gray-700" %>
              <%= select f, :group_id, @group_options, class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" %>
              <%= error_tag f, :group_id %>
            </div>
            <div class='p-2'>
              <%= submit "Speichern", class: "lg:mt-7 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white focus:outline-none #{if @modified, do: "bg-indigo-600 hover:bg-indigo-700 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500", else: "bg-indigo-200 text-indigo-500 cursor-not-allowed"}",
              disabled: not @modified %>
            </div>
          </div>
        </form>

        <%= live_patch "Passwort ändern", to: Routes.dsa_path(@socket, :reset_password),
        class: "w-full font-medium text-gray-600 py-2 px-4 w-full block hover:bg-gray-100 transition duration-150" %>

        <a href="#" class="hidden w-full border-t-2 border-gray-100 font-medium text-red-700 py-2 px-4 w-full block hover:bg-gray-100 transition duration-150">Account löschen</a>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, modified: false)}
  end

  def update(%{group_options: options, user: user}, socket) do
    {:ok, socket
    |> assign(:group_options, options)
    |> assign(:user_changeset, Accounts.change_user(user, %{}))
    |> assign(:user, user)}
  end

  def handle_event("activate", %{"character" => id}, socket) do
    id = if String.to_integer(id) == socket.assigns.user.active_character_id, do: nil, else: id

    case Accounts.update_user(socket.assigns.user, %{active_character_id: id}) do
      {:ok, _user} ->
        send self(), :update_user
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("An error occured when toggling active character: \n#{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"user" => params}, socket) do
    {:noreply, socket
    |> assign(:user_changeset, Accounts.change_user(socket.assigns.user, params))
    |> assign(:modified, true)}
  end

  def handle_event("delete", %{"character" => id}, socket) do
    character = Accounts.get_character!(id)

    case Accounts.delete_character(character) do
      {:ok, character} ->
        broadcast :update_user
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("An error occured when deleting character: \n#{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("update-character", %{"id" => id, "visible" => visible}, socket) do
    character = Enum.find(socket.assigns.user.characters, & &1.id == String.to_integer(id))

    case Accounts.update_character(character, %{visible: visible}) do
      {:ok, _character} ->
        broadcast :update_user
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("An error occured when updating character: \n#{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("update", %{"user" => params}, socket) do
    case Accounts.update_user(socket.assigns.user, params) do
      {:ok, user} ->
        broadcast :update_user
        {:noreply, assign(socket, :modified, false)}

      {:error, changeset} ->
        Logger.error("An error occured when updating user: \n#{inspect(changeset)}")
        {:noreply, socket}
    end
  end
end
