defmodule DsaWeb.GroupLive do
  use Phoenix.LiveView

  import DsaWeb.Gettext
  alias Dsa.Accounts
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
            <td class='small'><%= character.ini || character.ini_basis %></td>
            <td><%= character.name %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, %{"group_id" => group_id}, socket) do
    characters = Accounts.get_group_characters!(group_id)

    {:ok, socket
    |> assign(:group_id, group_id)
    |> assign(:characters, characters)}
  end
end
