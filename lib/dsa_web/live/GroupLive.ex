defmodule DsaWeb.GroupLive do
  use Phoenix.LiveView

  import DsaWeb.Gettext
  alias Dsa.{Accounts, Characters}
  require Logger

  def render(assigns) do
    ~L"""
    <table class="table">
      <thead>
        <tr>
          <th class='w-12'><%= gettext "INI" %></th>
          <th class='text-left'><%= gettext "Name" %></th>
        </tr>
      </thead>
      <tbody>
        <%= for character <- @characters do  %>
          <tr>
            <td class='small'>
              <button type='button' phx-click='roll-ini' phx-value-id='<%= character.id %>' class='button gray small'><%= character.ini || character.ini_basis %></button>
            </td>
            <td><%= character.name %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, %{"group_id" => group_id}, socket) do
    characters = Accounts.get_group_characters!(group_id)

    DsaWeb.Endpoint.subscribe(topic(group_id))

    {:ok, socket
    |> assign(:group_id, group_id)
    |> assign(:characters, characters)}
  end

  defp topic(id), do: "group:#{id}"

  def broadcast(group_id, message) do
    Phoenix.PubSub.broadcast!(Dsa.PubSub, topic(group_id), message)
  end

  def handle_event("roll-ini", %{"id" => id}, socket) do
    character = Enum.find(socket.assigns.characters, & &1.id == String.to_integer(id))

    ini = if is_nil(character.ini), do: character.ini_basis + Enum.random(1..6), else: nil

    case Characters.update(character, %{ini: ini}) do
      {:ok, character} ->
        characters = Accounts.get_group_characters!(socket.assigns.group_id)
        broadcast(socket.assigns.group_id, {:update, characters: characters})
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error inspect changeset.errors
        {:noreply, socket}
    end
  end

  def handle_info({:update, new_assigns}, socket) do
    {:noreply, assign(socket, new_assigns)}
  end
end
