defmodule DsaWeb.SkillComponent do
  use DsaWeb, :live_component

  alias Dsa.Accounts

  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset, "#", phx_change: :change, phx_submit: :update, phx_target: @myself %>
      <div class="shadow-xl overflow-hidden border-b rounded-lg">
        <table class="w-full border-gray-200 text-sm divide-y divide-gray-200 text-center">
          <thead class="leading-8 text-gray-900 bg-gray-300 font-medium">
            <tr>
              <th scope="col" class="px-2 text-left">Talent</th>
              <th scope="col" class="px-1 hidden sm:table-cell">Probe</th>
              <th scope="col" class="px-1 hidden sm:table-cell">BE</th>
              <th scope="col" class="px-1 hidden sm:table-cell">Stg.</th>
              <th scope="col" class="px-1">FW</th>
              <th scope="col" class="px-1 hidden sm:table-cell">R</th>
              <th scope="col" class="px-1"></th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr class=''>
              <th scope="row" class="px-2 text-left text-base">Körpertalente</th>
              <th scope="row" class="hidden sm:table-cell px-0">MU/GE/KK</th>
              <th colspan='2' scope="row" class="px-1 hidden sm:table-cell">188-194</th>
              <th scope="row" class="px-1">48 AP</th>
              <th colspan='2' scope="row" class="px-1"></th>
            </tr>
            <tr>
              <td class="px-2 py-1 text-left">Lebensmittelbearbeitung</td>
              <td class="px-1 py-1 hidden sm:table-cell">MU/IN/GE</td>
              <td class="px-1 py-1 hidden sm:table-cell">Ja</td>
              <td class="px-1 py-1 hidden sm:table-cell">B</td>
              <td class="px-0 py-1 w-12 text-center">
                <%= number_input f, :x1, class: "focus:ring-indigo-500 py-0 px-1 focus:border-indigo-500 block w-full border-gray-200 rounded-md" %>
              </td>
              <td class="px-1 py-1 hidden sm:table-cell">+3</td>
              <td class="px-1 py-1"></td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="px-4 py-3 text-center sm:px-6">
        <%= submit button_text(:update, @modified),
          class: "inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white focus:outline-none   #{if @modified, do: "bg-indigo-600 hover:bg-indigo-700 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500", else: "bg-indigo-200 text-indigo-500 cursor-not-allowed"}",
          disabled: not @modified
        %>
      </div>
    </form>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, modified: false)}
  end

  def update(assigns, socket) do
    {:ok, socket
    |> assign(:changeset, Accounts.change_character(assigns.character))
    |> assign(:user_id, assigns.user_id)}
  end

  def handle_event("change", %{"character" => params}, socket) do
    changeset = Accounts.change_character(socket.assigns.changeset.data, params)
    {:noreply, assign(socket, changeset: changeset, modified: true)}
  end

  def handle_event("update", %{"character" => params}, socket) do
    case Accounts.update_character(socket.assigns.changeset.data, params) do
      {:ok, character} ->
        send self(), {:update_character, character}
        {:noreply, socket
        |> assign(:changeset, Accounts.change_character(character))
        |> assign(:modified, false)}

      {:error, changeset} ->
        Logger.error("Error occured while updating character: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  defp button_text(action, modified?) do
    case {action, modified?} do
      {_, true} -> "Speichern"
      {:create, false} -> "Unverändert..."
      {:update, false} -> "Gespeichert"
    end
  end
end
