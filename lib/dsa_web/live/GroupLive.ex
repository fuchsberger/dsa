defmodule DsaWeb.GroupLive do
  use Phoenix.LiveView

  import DsaWeb.Gettext
  import DsaWeb.GroupView

  alias Dsa.{Accounts, Characters, Logs}
  alias Dsa.Logs.Event.Type.{INIRoll}
  alias DsaWeb.LogLive

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
              <%= if character.user_id != @user_id do %>
                <%= character.ini %>
              <% else %>
                <%= ini_button(@socket, character) %>
              <% end %>
            </td>
            <td><%= character.name %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, %{"group_id" => group_id, "user_id" => user_id}, socket) do
    characters = Accounts.get_group_characters!(group_id)

    DsaWeb.Endpoint.subscribe(topic(group_id))

    {:ok, socket
    |> assign(:characters, characters)
    |> assign(:group_id, group_id)
    |> assign(:user_id, user_id)}
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

        log_params = %{
          type: INIRoll,
          group_id: socket.assigns.group_id,
          character_id: character.id,
          character_name: character.name,
          roll: ini
        }

        case Logs.create_event(log_params) do
          {:ok, entry} ->
            broadcast(socket.assigns.group_id, {:update, characters: characters})
            LogLive.broadcast(socket.assigns.group_id, {:log, entry})

          {:error, changeset} ->
            Logger.error inspect changeset
            {:noreply, socket}
        end

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
