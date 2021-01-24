defmodule DsaWeb.RollComponent do
  use DsaWeb, :live_component

  import DsaWeb.DsaLive, only: [topic: 0]

  alias Dsa.{Accounts, Event}

  @group_id 1

  def render(assigns) do
    ~L"""

    <%= f = form_for @roll_changeset, "#", phx_change: "change", phx_target: @myself, phx_submit: "roll" %>
      <div class='grid grid-cols-3 md:grid-cols-9 border-solid border-gray-300 border-b pb-3 gap-2'>
        <h4 class='col-span-2 leading-8 text-center lg:text-left font-bold text-gray-700'>Schnellwurf</h4>

        <%= quickroll_button %{target: @myself, max: 20, count: 1} %>
        <%= quickroll_button %{target: @myself, max: 6, count: 1} %>
        <%= quickroll_button %{target: @myself, max: 6, count: 2} %>
        <%= quickroll_button %{target: @myself, max: 6, count: 3} %>
        <%= quickroll_button %{target: @myself, max: 20, count: 3} %>

        <div class="col-span-2 flex justify-end">
          <%= label f, :bonus, "+", class: "leading-8 mr-2" %>
          <%= number_input f, :bonus, placeholder: 0, class: "w-16 h-8 block py-0 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" %>
        </div>
      </div>

      <div class='grid grid-cols-1 md:grid-cols-3 py-3 gap-3'>
        <div class='flex justify-between'>
          <h4 class='leading-8 text-center lg:text-left font-bold text-gray-700'>Modifikator</h4>
          <label class='bg-white h-8 leading-8 px-2 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500'>
            <%= radio_button(f, :modifier, 0,
              checked: input_value(f, :modifier) == 0,
              class: "hidden"
              )
            %> reset
          </label>
        </div>

        <div class="flex text-sm font-medium">
          <%= modifier_field f, -6 %>
          <%= modifier_field f, -5 %>
          <%= modifier_field f, -4 %>
          <%= modifier_field f, -3 %>
          <%= modifier_field f, -2 %>
          <%= modifier_field f, -1 %>

        </div>

        <div class="flex text-sm font-medium">
          <%= modifier_field f, 1 %>
          <%= modifier_field f, 2 %>
          <%= modifier_field f, 3 %>
          <%= modifier_field f, 4 %>
          <%= modifier_field f, 5 %>
          <%= modifier_field f, 6 %>
        </div>
      </div>

      <div class='grid grid-cols-1 lg:grid-cols-5 gap-2 mb-3'>
        <h4 class='leading-8 text-center lg:text-left font-bold text-gray-700'>Eigenschaft</h4>
        <div class='col-span-2 grid grid-cols-4 gap-2'>
          <%= trait_button("MU", @mu, @myself) %>
          <%= trait_button("KL", @kl, @myself) %>
          <%= trait_button("IN", @int, @myself) %>
          <%= trait_button("CH", @ch, @myself) %>
        </div>
        <div class='col-span-2 grid grid-cols-4 gap-2'>
          <%= trait_button("GE", @ge, @myself) %>
          <%= trait_button("FF", @ff, @myself) %>
          <%= trait_button("KO", @ko, @myself) %>
          <%= trait_button("KK", @kk, @myself) %>
        </div>
      </div>


      <div class='grid grid-cols-1 lg:grid-cols-5 gap-2'>

        <h4 class='leading-8 text-center lg:text-left font-bold text-gray-700'>Talentprobe</h4>

        <div class='col-span-2 grid grid-cols-3 gap-2'>
          <%= select f, :e1, ["MU": "0", "KL": "1", "IN": "2", "CH": "3", "GE": "4", "FF": "5", "KO": "6", "KK": "7"], class: "block h-8 leading-8 px-3 py-0 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500" %>

          <%= select f, :e2, ["MU": "0", "KL": "1", "IN": "2", "CH": "3", "GE": "4", "FF": "5", "KO": "6", "KK": "7"], class: "block h-8 leading-8 px-3 py-0 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500" %>

          <%= select f, :e3, ["MU": "0", "KL": "1", "IN": "2", "CH": "3", "GE": "4", "FF": "5", "KO": "6", "KK": "7"], class: "block h-8 leading-8 px-3 py-0 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500" %>
        </div>

        <div class='col-span-2 grid grid-cols-3 gap-2'>

          <%= label f, :tw, "TW", class: "leading-8 font-bold text-right" %>

          <%= number_input f, :tw, class: "block h-8 leading-8 px-3 text-center border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm", placeholder: "TW" %>

          <button type='button' class="bg-white py-0 w-full border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='talent-roll' phx-target='<%= @myself %>'>Würfel!</button>
        </div>
      </div>
    </form>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, :roll_changeset, Dsa.UI.change_roll())}
  end

  def preload(list_of_assigns) do
    list_of_ids = Enum.map(list_of_assigns, & &1.character_id)

    characters = Accounts.list_characters(list_of_ids)

    Enum.map(list_of_assigns, fn assigns ->
      Map.put(assigns, :character, characters[assigns.character_id])
    end)
  end

  def update(assigns, socket) do
    character = Map.get(assigns, :character)

    {:ok, socket
    |> assign(:character_id, character.id)
    |> assign(:mu, character.mu)
    |> assign(:kl, character.kl)
    |> assign(:int, character.in)
    |> assign(:ch, character.ch)
    |> assign(:ge, character.ge)
    |> assign(:ff, character.ff)
    |> assign(:ko, character.ko)
    |> assign(:kk, character.kk)}
  end

  def handle_event("change", %{"roll" => params}, socket) do
    {:noreply, assign(socket, :roll_changeset, Dsa.UI.change_roll(params))}
  end

  def handle_event("quickroll", %{"max" => max, "count" => count}, socket) do

    count = String.to_integer(count)
    max = String.to_integer(max)
    bonus = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :bonus)
    rolls = Enum.map(1..8, & (if count >= &1, do: Enum.random(1..max), else: nil))
    result = Enum.reduce(rolls, bonus, fn x, sum -> if is_nil(x), do: sum, else: sum + x end)

    params = %{
      type: 1,
      x1: Enum.at(rolls, 0),
      x2: Enum.at(rolls, 1),
      x3: Enum.at(rolls, 2),
      x4: Enum.at(rolls, 3),
      x5: Enum.at(rolls, 4),
      x6: Enum.at(rolls, 5),
      x7: Enum.at(rolls, 6),
      x8: Enum.at(rolls, 7),
      x9: bonus,
      x10: max, # dice type
      x11: count, # dice count
      x12: result, # sum + bonus
      character_id: socket.assigns.character_id,
      group_id: @group_id
    }

    case Event.create_log(params) do
      {:ok, log} ->
        broadcast_log!(log)
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("roll", %{"trait" => trait}, socket) do

    trait = trait |> String.downcase() |> String.to_atom()
    trait_value = Map.get(socket.assigns, trait, socket.assigns.int)
    modifier = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :modifier)
    dice = Enum.random(1..20)
    dice_confirm = Enum.random(1..20)

    result =
      cond do
        dice == 1 && dice_confirm <= trait_value + modifier -> 2
        dice == 1 -> 1
        dice == 20 && dice_confirm > trait_value + modifier -> -2
        dice == 20 -> -1
        dice <= trait_value + modifier -> 1
        true -> -1
      end

    params =
      %{
        type: 2,
        x1: Enum.find_index(~w(mu kl in ch ge ff ko kk)a, & &1 == trait), # trait
        x2: trait_value,
        x3: modifier,
        x4: dice,
        x5: dice_confirm,
        x12: result,
        character_id: socket.assigns.character_id,
        group_id: @group_id
      }

    case Event.create_log(params) do
      {:ok, log} ->
        broadcast_log!(log)
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("talent-roll", _params, socket) do

    # trait indexes
    trait_1 = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :e1)
    trait_2 = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :e2)
    trait_3 = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :e3)

    # trait values
    trait_value_1 = Map.get(socket.assigns, Enum.at(~w(mu kl int ch ge ff ko kk)a, trait_1))
    trait_value_2 = Map.get(socket.assigns, Enum.at(~w(mu kl int ch ge ff ko kk)a, trait_2))
    trait_value_3 = Map.get(socket.assigns, Enum.at(~w(mu kl int ch ge ff ko kk)a, trait_3))

    dice_1 = Enum.random(1..20)
    dice_2 = Enum.random(1..20)
    dice_3 = Enum.random(1..20)

    modifier = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :modifier)
    talent_value = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :tw)

    result =
      cond do
        Enum.count([dice_1, dice_2, dice_3], & &1 == 1) >= 2 -> 10 # critical success
        Enum.count([dice_1, dice_2, dice_3], & &1 == 20) >= 2 -> -2 # critical failure
        true ->
          # count spent tw
          remaining = talent_value - max(dice_1 - trait_value_1 - modifier, 0) - max(dice_2 - trait_value_2 - modifier, 0) - max(dice_3 - trait_value_3 - modifier, 0)

          cond do
            remaining < 0 -> -1 # normal failure
            true -> div(remaining, 3) + 1 # normal success => show quality
          end
      end

    params =
      %{
        type: 3,
        x1: trait_1,
        x2: trait_2,
        x3: trait_3,
        x4: trait_value_1,
        x5: trait_value_2,
        x6: trait_value_3,
        x7: dice_1,
        x8: dice_2,
        x9: dice_3,
        x10: modifier,
        x11: talent_value,
        x12: result,
        character_id: socket.assigns.character_id,
        group_id: @group_id
      }


    case Event.create_log(params) do
      {:ok, log} ->
        broadcast_log!(log)
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  defp broadcast_log!(log) do
    # DsaWeb.Endpoint.broadcast!(topic(), "log", Dsa.Repo.preload(log, :character))
    Phoenix.PubSub.broadcast!(Dsa.PubSub, topic(), {:log, Event.preload_character_name(log)})
  end

  defp modifier_field(form, value) do
    active = input_value(form, :modifier) == value

    rounded_class =
      case value do
        -6 -> " rounded-l-md"
        -1 -> " rounded-r-md"
        6  -> " rounded-r-md"
        1  -> " rounded-l-md"
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

    label class: "w-1/6 leading-8 h-8 text-center border #{rounded_class} #{extra_classes}" do
      [
        radio_button(form, :modifier, value, checked: active, class: "hidden"),
        "#{value}"
      ]
    end
  end

  defp quickroll_button(assigns) do
    ~L"""
    <button type='button'
      phx-click="quickroll"
      phx-value-count="<%= @count %>"
      phx-value-max="<%= @max %>"
      phx-target="<%= @target %>"
      class="bg-white w-full h-8 leading-8 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"><%= if @count > 1, do: @count %>W<%= @max %></button>
    """
  end

  defp trait_button(trait, value, target) do
    assigns = %{trait: trait, target: target, value: value}
    ~L"""
    <button type='button' class="bg-white w-full h-8 leading-8 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='roll' phx-target='<%= @target %>' phx-value-trait='<%= trait %>'><%= trait %> <%= @value %></button>
    """
  end
end
