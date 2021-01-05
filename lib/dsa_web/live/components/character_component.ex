defmodule DsaWeb.CharacterComponent do
  use DsaWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="absolute inset-0">
      <%= f = form_for @character_changeset, "#", phx_change: :change, phx_submit: :update, phx_target: @myself %>
        <div class='mt-3 px-3 grid grid-cols-1 lg:grid-cols-2 gap-6'>
          <div class="">
            <%= label f, :name, "Name", class: "block text-sm font-medium text-gray-700" %>
            <%= text_input f, :name, class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md", placeholder: "Name" %>
          </div>

          <div class="">
            <%= label f, :profession, "Profession", class: "block text-sm font-medium text-gray-700" %>
            <%= text_input f, :profession, class: "mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md", placeholder: "Profession" %>
          </div>
        </div>

        <div class='mt-3 px-3 grid grid-cols-4 lg:grid-cols-8 gap-2 lg:gap-3'>
          <div>
            <%= label f, :mu, "MU", class: "block text-center text-sm font-medium text-gray-700" %>
            <%= number_input f, :mu, class: "mt-1 text-center focus:ring-indigo-500 py-0 px-1 focus:border-indigo-500 block w-full shadow-sm lg:text-lg border-gray-300 rounded-md", placeholder: "MU" %>
          </div>
          <div>
            <%= label f, :kl, "KL", class: "block text-center text-sm font-medium text-gray-700" %>
            <%= number_input f, :kl, class: "mt-1 text-center focus:ring-indigo-500 py-0 px-1 focus:border-indigo-500 block w-full shadow-sm lg:text-lg border-gray-300 rounded-md", placeholder: "KL" %>
          </div>
          <div>
            <%= label f, :in, "IN", class: "block text-center text-sm font-medium text-gray-700" %>
            <%= number_input f, :in, class: "mt-1 text-center focus:ring-indigo-500 py-0 px-1 focus:border-indigo-500 block w-full shadow-sm lg:text-lg border-gray-300 rounded-md", placeholder: "IN" %>
          </div>
          <div>
            <%= label f, :ch, "CH", class: "block text-center text-sm font-medium text-gray-700" %>
            <%= number_input f, :ch, class: "mt-1 text-center focus:ring-indigo-500 py-0 px-1 focus:border-indigo-500 block w-full shadow-sm lg:text-lg border-gray-300 rounded-md", placeholder: "CH" %>
          </div>
          <div>
            <%= label f, :ge, "GE", class: "block text-center text-sm font-medium text-gray-700" %>
            <%= number_input f, :ge, class: "mt-1 text-center focus:ring-indigo-500 py-0 px-1 focus:border-indigo-500 block w-full shadow-sm lg:text-lg border-gray-300 rounded-md", placeholder: "GE" %>
          </div>
          <div>
            <%= label f, :ff, "FF", class: "block text-center text-sm font-medium text-gray-700" %>
            <%= number_input f, :ff, class: "mt-1 text-center focus:ring-indigo-500 py-0 px-1 focus:border-indigo-500 block w-full shadow-sm lg:text-lg border-gray-300 rounded-md", placeholder: "FF" %>
          </div>
          <div>
            <%= label f, :ko, "KO", class: "block text-center text-sm font-medium text-gray-700" %>
            <%= number_input f, :ko, class: "mt-1 text-center focus:ring-indigo-500 py-0 px-1 focus:border-indigo-500 block w-full shadow-sm lg:text-lg border-gray-300 rounded-md", placeholder: "KO" %>
          </div>
          <div>
            <%= label f, :kk, "KK", class: "block text-center text-sm font-medium text-gray-700" %>
            <%= number_input f, :kk, class: "mt-1 text-center focus:ring-indigo-500 py-0 px-1 focus:border-indigo-500 block w-full shadow-sm lg:text-lg border-gray-300 rounded-md", placeholder: "KK" %>
          </div>
        </div>
        <div class="px-4 py-3 text-center sm:px-6">
          <%= submit (unless @modified, do: "Gespeichert", else: "Speichern"),
            class: "inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white focus:outline-none   #{if @modified, do: "bg-indigo-600 hover:bg-indigo-700 focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500", else: "bg-indigo-200 text-indigo-500 cursor-not-allowed"}",
            disabled: not @modified
          %>
        </div>
      </form>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, modified: false)}
  end

  def preload([%{character_id: character_id}]) do
    [%{character: Dsa.Accounts.get_character!(character_id)}]
  end

  def update(%{character: character}, socket) do
    {:ok, socket
    |> assign(:character, character)
    |> assign(:character_changeset, Dsa.Accounts.change_character(character))}
  end

  def handle_event("change", %{"character" => params}, socket) do
    changeset = Dsa.Accounts.change_character(socket.assigns.character, params)
    {:noreply, assign(socket, character_changeset: changeset, modified: true)}
  end

  def handle_event("update", %{"character" => params}, socket) do
    case Dsa.Accounts.update_character(socket.assigns.character, params) do
      {:ok, character} ->
        {:noreply, socket
        |> assign(:character, character)
        |> assign(:character_changeset, Dsa.Accounts.change_character(character))
        |> assign(:modified, false)}

      {:error, changeset} ->
        Logger.error("Error occured while updating character: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end
end
