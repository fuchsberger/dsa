defmodule DsaWeb.RollComponent do
  use DsaWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="absolute inset-0">
      <div class='grid grid-cols-1 md:grid-cols-2 border-solid border-gray-300 border-b py-2'>
        <h4 class='mb-0 py-1 text-center font-bold text-gray-700'>Schnellwurf</h4>

        <div class="flex justify-center">
          <button phx-click='quickroll' phx-value-type='w20' type="button" class="bg-white py-2 px-3 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 mr-2 lg:mr-3">W20</button>

          <button phx-click='quickroll' phx-value-type='w6' type="button" class="bg-white py-2 px-3 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 mr-2 lg:mr-3">W6</button>

          <button phx-click='quickroll' phx-value-type='2w6' type="button" class="bg-white py-2 px-3 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 mr-2 lg:mr-3">2W6</button>

          <button phx-click='quickroll' phx-value-type='3w6' type="button" class="bg-white py-2 px-3 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 mr-2 lg:mr-3">3W6</button>

          <button phx-click='quickroll' phx-value-type='3w20' type="button" class="bg-white py-2 px-3 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">3W20</button>
        </div>
      </div>

      <%= f = form_for @roll_changeset, "#", phx_change: "change", phx_submit: "roll" %>

        <div class='grid grid-cols-1 md:grid-cols-2 py-2'>
          <h4 class='mb-0 py-1 text-center font-bold text-gray-700'>Modifikator</h4>

          <div class="flex justify-center -space-x-px text-sm font-medium">
            <%= modifier_field f, -6 %>
            <%= modifier_field f, -5 %>
            <%= modifier_field f, -4 %>
            <%= modifier_field f, -3 %>
            <%= modifier_field f, -2 %>
            <%= modifier_field f, -1 %>
            <%= modifier_field f, 0 %>
            <%= modifier_field f, 1 %>
            <%= modifier_field f, 2 %>
            <%= modifier_field f, 3 %>
            <%= modifier_field f, 4 %>
            <%= modifier_field f, 5 %>
            <%= modifier_field f, 6 %>
          </div>
        </div>

        <div class='grid grid-cols-3 lg:grid-cols-6 py-2 gap-3 lg:gap-4'>
          <h4 class='mb-0 py-1 text-center font-bold text-gray-700'>Talentprobe</h4>

          <%= select f, :e1, ["MU": "0", "KL": "1", "IN": "2", "CH": "3", "GE": "4", "FF": "5", "KO": "6", "KK": "7"], class: "mt-1 block py-0 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" %>

          <%= select f, :e2, ["MU": "0", "KL": "1", "IN": "2", "CH": "3", "GE": "4", "FF": "5", "KO": "6", "KK": "7"], class: "mt-1 block py-0 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" %>

          <%= select f, :e3, ["MU": "0", "KL": "1", "IN": "2", "CH": "3", "GE": "4", "FF": "5", "KO": "6", "KK": "7"], class: "mt-1 block py-0 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" %>

          <%= number_input f, :tw, class: "mt-1 block py-0 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm", placeholder: "TW" %>

          <button type='button' class="bg-white py-0 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='talent-roll'>Würfel!</button>
        </div>

        <h4 class='mb-0 py-1 text-center font-bold text-gray-700'>Eigenschaftsprobe</h4>
        <div class='grid grid-cols-4 lg:grid-cols-8 gap-3 px-2 lg:px-3 lg:gap-4'>

          <button type='button' class="bg-white py-2 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='roll' phx-value-trait='mu'>Mu: <%= @character.mu %></button>

          <button type='button' class="bg-white py-2 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='roll' phx-value-trait='kl'>KL: <%= @character.kl %></button>

          <button type='button' class="bg-white py-2 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='roll' phx-value-trait='in'>IN: <%= @character.in %></button>

          <button type='button' class="bg-white py-2 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='roll' phx-value-trait='ch'>CH: <%= @character.ch %></button>

          <button type='button' class="bg-white py-2 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='roll' phx-value-trait='ge'>GE: <%= @character.ge %></button>

          <button type='button' class="bg-white py-2 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='roll' phx-value-trait='ff'>FF: <%= @character.ff %></button>

          <button type='button' class="bg-white py-2 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='roll' phx-value-trait='ko'>KO: <%= @character.ko %></button>

          <button type='button' class="bg-white py-2 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='roll' phx-value-trait='kk'>KK: <%= @character.kk %></button>
        </div>
      </form>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, :roll_changeset, Dsa.UI.change_roll())}
  end

  def preload([%{character_id: character_id}]) do
    [%{character: Dsa.Accounts.get_character!(character_id)}]
  end

  def update(%{character: character}, socket) do
    {:ok, socket
    |> assign(:character, character)}
  end

  def handle_event("change", %{"roll" => params}, socket) do
    {:noreply, socket
    |> assign(:roll_changeset, Dsa.UI.change_roll(params))}
  end

  def handle_event("quickroll", %{"type" => type}, socket) do

    params =
      case type do
        "w20" ->
          %{
            type: 1,
            x1: Enum.random(1..20),
            character_id: socket.assigns.user.active_character_id,
            group_id: socket.assigns.group_id
          }

        "w6" ->
          %{
            type: 2,
            x1: Enum.random(1..6),
            character_id: socket.assigns.user.active_character_id,
            group_id: socket.assigns.group_id
          }

        "2w6" ->
          %{
            type: 3,
            x1: Enum.random(1..6),
            x2: Enum.random(1..6),
            character_id: socket.assigns.user.active_character_id,
            group_id: socket.assigns.group_id
          }

        "3w6" ->
          %{
            type: 4,
            x1: Enum.random(1..6),
            x2: Enum.random(1..6),
            x3: Enum.random(1..6),
            character_id: socket.assigns.user.active_character_id,
            group_id: socket.assigns.group_id
          }

        "3w20" ->
          %{
            type: 5,
            x1: Enum.random(1..20),
            x2: Enum.random(1..20),
            x3: Enum.random(1..20),
            character_id: socket.assigns.user.active_character_id,
            group_id: socket.assigns.group_id
          }
      end

    case Event.create_log(params) do
      {:ok, log} ->
        DsaWeb.Endpoint.broadcast(DsaWeb.DsaLive.topic(), "log", Repo.preload(log, :character))
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("roll", %{"trait" => trait}, socket) do

    trait = String.to_atom(trait)

    params =
      %{
        type: 6,
        x1: Enum.find_index(~w(mu kl in ch ge ff ko kk)a, & &1 == trait), # trait
        x2: Map.get(socket.assigns.user.active_character, trait), # trait value
        x3: Ecto.Changeset.get_field(socket.assigns.roll_changeset, :modifier), # modifier
        x4: Enum.random(1..20), # result
        x5: Enum.random(1..20), # result confirmation
        character_id: socket.assigns.user.active_character_id,
        group_id: socket.assigns.group_id
      }

    case Event.create_log(params) do
      {:ok, log} ->
        DsaWeb.Endpoint.broadcast(DsaWeb.DsaLive.topic(), "log", Repo.preload(log, :character))
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("talent-roll", _params, socket) do

    trait_1 = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :e1)
    trait_2 = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :e2)
    trait_3 = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :e3)

    trait_value_1 = Enum.at(~w(mu kl in ch ge ff ko kk)a, trait_1)
    trait_value_2 = Enum.at(~w(mu kl in ch ge ff ko kk)a, trait_2)
    trait_value_3 = Enum.at(~w(mu kl in ch ge ff ko kk)a, trait_3)

    params =
      %{
        type: 7,
        x1: trait_1,
        x2: trait_2,
        x3: trait_3,
        x4: Map.get(socket.assigns.user.active_character, trait_value_1),
        x5: Map.get(socket.assigns.user.active_character, trait_value_2),
        x6: Map.get(socket.assigns.user.active_character, trait_value_3),
        x7: Enum.random(1..20),
        x8: Enum.random(1..20),
        x9: Enum.random(1..20),
        x10: Ecto.Changeset.get_field(socket.assigns.roll_changeset, :modifier),
        x11: Ecto.Changeset.get_field(socket.assigns.roll_changeset, :tw),
        character_id: socket.assigns.user.active_character_id,
        group_id: socket.assigns.group_id
      }

    case Event.create_log(params) do
      {:ok, log} ->
        DsaWeb.Endpoint.broadcast(DsaWeb.DsaLive.topic(), "log", Repo.preload(log, :character))
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  defp modifier_field(form, value) do
    active = input_value(form, :modifier) == value

    rounded_class =
      case value do
        -6 -> " rounded-l-md"
        6 -> " rounded-r-md"
        _ -> nil
      end

    extra_classes =
      cond do
        value < 0 && active ->     "text-red-800 bg-red-200 border-red-400"
        value < 0 && not active -> "text-red-800 bg-red-50 border-gray-300"
        value > 0 && active ->     "text-green-800 bg-green-200 border-green-400"
        value > 0 && not active -> "text-green-800 bg-green-50 border-gray-300"
        true ->                    "text-gray-700 bg-gray-50 border-gray-300"
      end

    label class: "w-9 py-1 text-center border #{rounded_class} #{extra_classes}" do
      [
        radio_button(form, :modifier, value, checked: active, class: "hidden"),
        "#{value}"
      ]
    end
  end

  defp trait_roll_button(trait, user) do

    trait_name =
      trait
      |> Atom.to_string()
      |> String.upcase()

    case user && user.active_character do
      true ->
        content_tag :button, "#{trait_name}: #{Map.get(user.active_character, trait)}",
          type: "button",
          class: "bg-white py-2 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500",
          phx_click: "roll",
          phx_value_trait: trait

      nil ->
        nil
    end
  end
end
