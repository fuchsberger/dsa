defmodule DsaWeb.CombatComponent do
  @moduledoc """
  This places an interactive overview table of all (visible) characters in a group for combat.
  """
  use DsaWeb, :live_component

  alias Dsa.Accounts

  @group_id 1

  def render(assigns) do
    ~L"""
    <div class='shadow-xl overflow-hidden border-b sm:rounded-lg'>
      <table class='w-full leading-8 border-gray-200 divide-y divide-gray-200'>
        <thead class="text-gray-900 bg-gray-300 font-medium">
          <tr>
            <th scope="col" class="px-2 text-left">Held</th>
            <th scope="col" class="w-12">LE</th>
            <th scope="col" class="w-12">AE</th>
            <th scope="col" class="w-12">KE</th>
          </tr>
        </thead>
        <tbody class='bg-white divide-y divide-gray-200'>
        <%= for c <- @visible_characters do %>
          <tr>
            <td class="px-2"><%= c.name %></td>
            <td class='text-center'>
              <%= if c.user_id == @user.id do %>
                <%= f = form_for :character, "#", phx_change: :update, phx_target: @myself, phx_submit: :submit %>
                <%= hidden_input f, :character_id, value: c.id %>
                <%= number_input f, :le,
                  class: "focus:ring-indigo-500 py-0 pl-1 w-11 px-0 focus:border-indigo-500 block shadow-sm lg:text-lg border-gray-300 rounded-md",
                  min: 0,
                  max: c.le_max,
                  value: c.le
                %>
                </form>
              <% else %>
                <%= c.le %>/<%= c.le_max %>
              <% end %>
            </td>
            <td class='text-center'>
              <%= if c.user_id == @user.id do %>
                <%= f = form_for :character, "#", phx_change: :update, phx_target: @myself, phx_submit: :submit %>
                <%= hidden_input f, :character_id, value: c.id %>
                <%= number_input f, :ae,
                  class: "focus:ring-indigo-500 py-0 pl-1 w-11 px-0 focus:border-indigo-500 block shadow-sm lg:text-lg border-gray-300 rounded-md",
                  min: 0,
                  max: c.ae_max,
                  value: c.ae
                %>
                </form>
              <% else %>
                <%= c.ae %>/<%= c.ae_max %>
              <% end %>
            </td>
            <td class='text-center'>
              <%= if c.user_id == @user.id do %>
                <%= f = form_for :character, "#", phx_change: :update, phx_target: @myself, phx_submit: :submit %>
                <%= hidden_input f, :character_id, value: c.id %>
                <%= number_input f, :ke,
                  class: "focus:ring-indigo-500 py-0 pl-1 w-11 px-0 focus:border-indigo-500 block shadow-sm lg:text-lg border-gray-300 rounded-md",
                  min: 0,
                  max: c.ke_max,
                  value: c.ke
                %>
                </form>
              <% else %>
                <%= c.ke %>/<%= c.ke_max %>
              <% end %>
            </td>
          </tr>
        <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  def mount(socket), do: {:ok, socket}

  def handle_event("update", %{"character" => params}, socket) do
    character_id = params |> Map.get("character_id") |> String.to_integer()
    character = Enum.find(socket.assigns.visible_characters, & &1.id == character_id)

    case Accounts.update_character(character, params) do
      {:ok, _character} ->
        broadcast :update_user
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while submitting character: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("submit", _params, socket), do: {:noreply, socket}
end
