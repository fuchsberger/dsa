defmodule DsaWeb.RollComponent do
  use DsaWeb, :live_component

  alias Dsa.Event

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

      <div class='grid grid-cols-1 lg:grid-cols-5 gap-2'>

        <h4 class='leading-8 text-center lg:text-left font-bold text-gray-700'>Talentprobe</h4>

        <div class='col-span-2 grid grid-cols-3 gap-2'>
          <%= select f, :e1, trait_options(), class: "block h-8 leading-8 px-3 py-0 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500" %>

          <%= select f, :e2, trait_options(), class: "block h-8 leading-8 px-3 py-0 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500" %>

          <%= select f, :e3, trait_options(), class: "block h-8 leading-8 px-3 py-0 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500" %>
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
      character_id: socket.assigns.character.id,
      group_id: @group_id
    }

    case Event.create_log(params) do
      {:ok, log} ->
        broadcast({:log, Event.preload_character_name(log)})
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("talent-roll", _params, socket) do

    # trait indexes
    trait_1 = socket.assigns.roll_changeset |> Ecto.Changeset.get_field(:e1) |> String.to_atom()
    trait_2 = socket.assigns.roll_changeset |> Ecto.Changeset.get_field(:e2) |> String.to_atom()
    trait_3 = socket.assigns.roll_changeset |> Ecto.Changeset.get_field(:e3) |> String.to_atom()

    # trait values
    t1 = Map.get(socket.assigns.character, trait_1)
    t2 = Map.get(socket.assigns.character, trait_2)
    t3 = Map.get(socket.assigns.character, trait_3)

    d1 = Enum.random(1..20)
    d2 = Enum.random(1..20)
    d3 = Enum.random(1..20)

    level = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :tw)

    Logger.warn(inspect({trait_1, trait_2, trait_3, t1, t2, t3, level, socket.assigns.modifier, d1, d2, d3}))

    params =
      %{
        type: 3,
        x1: Enum.find_index(~w(mu kl in ch ge ff ko kk)a, & &1 == trait_1),
        x2: Enum.find_index(~w(mu kl in ch ge ff ko kk)a, & &1 == trait_2),
        x3: Enum.find_index(~w(mu kl in ch ge ff ko kk)a, & &1 == trait_3),
        x7: d1,
        x8: d2,
        x9: d3,
        x10: socket.assigns.modifier,
        x12: DsaWeb.SkillComponent.result(t1, t2, t3, level, socket.assigns.modifier, d1, d2, d3),
        character_id: socket.assigns.character.id,
        group_id: @group_id
      }

    case Event.create_log(params) do
      {:ok, log} ->
        broadcast({:log, Event.preload_character_name(log)})
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
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

  defp trait_options, do: Enum.map(~w(mu kl in ch ff ge ko kk), & {String.upcase(&1), &1})
end
