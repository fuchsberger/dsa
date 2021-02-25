defmodule DsaWeb.SpellComponent do
  use DsaWeb, :live_component

  alias Dsa.Data.Spell
  alias Dsa.{Event}

  @group_id 1

  def render(assigns) do
    ~L"""
    <table class="w-full shadow-xl border-gray-200 rounded-lg text-sm divide-y divide-gray-200 text-center">
      <thead class="leading-8 text-gray-900 bg-gray-300 font-medium">
        <tr>
          <th scope="col" class="px-2 text-left">Spells</th>
          <th scope="col" class="px-1 hidden sm:table-cell">Probe</th>
          <th scope="col" class="px-1 hidden sm:table-cell">SF</th>
          <th scope="col" colspan='3'>FW</th>
          <th scope="col">P</th>
        </tr>
      </thead>
      <tbody class="bg-white divide-y divide-gray-200">
        <%= header_row("Zauber", "-", "xxx-xxx", @ap_1) %>
          <%= for spell_id <- 1..51 do %><%= row(@myself, @character, spell_id) %><% end %>
      </tbody>
    </table>
    """
  end


  def mount(socket), do: {:ok, socket}

  def update(%{character: character, modifier: modifier}, socket) do
    {:ok, socket
    |> assign(:character, character)
    |> assign(:modifier, modifier)
    |> assign(:ap_1, ap(character, :skills, 1))
    |> assign(:ap_2, ap(character, :skills, 2))
    |> assign(:ap_3, ap(character, :skills, 3))
    |> assign(:ap_4, ap(character, :skills, 4))
    |> assign(:ap_5, ap(character, :skills, 5))}
  end

  def handle_event("roll", %{"spell" => id}, socket) do
    spell_id = String.to_integer(id)
    level = Map.get(socket.assigns.character, Spell.field(spell_id))
    [t1, t2, t3] = Enum.map(Spell.traits(spell_id), & Map.get(socket.assigns.character, &1))
    traits = [t1, t2, t3]

    dices = Dsa.Trial.roll_dices(20, 3)
    [{_, d1}, {_, d2}, {_, d3}] = dices
    result = Dsa.Trial.perform_talent_trial(traits, level, socket.assigns.modifier, dices)

    params =
      %{
        type: 5,
        x1: spell_id,
        x7: d1,
        x8: d2,
        x9: d3,
        x10: socket.assigns.modifier,
        x12: result,
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

  defp header_row(category, probe, pages, ap) do
    assigns = %{category: category, probe: probe, ap: ap, pages: pages}
    ~L"""
    <tr>
      <th scope="row" class="px-2 text-left text-base"><%= @category %></th>
      <th scope="row" class="hidden sm:table-cell px-0"><%= @probe %></th>
      <th colspan='2' scope="row" class="px-1 hidden sm:table-cell"><%= @pages %></th>
      <th colspan='3' scope="row"><%= @ap %> AP</th>
      <th scope="row" class="px-1">
        <svg class='inline-block w-4 h-4' viewBox="0 0 20 20" fill="currentColor">
          <path d="M11 17a1 1 0 001.447.894l4-2A1 1 0 0017 15V9.236a1 1 0 00-1.447-.894l-4 2a1 1 0 00-.553.894V17zM15.211 6.276a1 1 0 000-1.788l-4.764-2.382a1 1 0 00-.894 0L4.789 4.488a1 1 0 000 1.788l4.764 2.382a1 1 0 00.894 0l4.764-2.382zM4.447 8.342A1 1 0 003 9.236V15a1 1 0 00.553.894l4 2A1 1 0 009 17v-5.764a1 1 0 00-.553-.894l-4-2z" />
        </svg>
      </th>
    </tr>
    """
  end

  defp row(target, spell_values, spell_id) do
    field = Spell.field(spell_id)
    value = Map.get(spell_values, field)

    assigns = %{
      id: spell_id,
      name: Spell.name(spell_id),
      probe: Spell.probe(spell_id),
      sf: Spell.sf(spell_id),
      value: value,
      show_minus: (if value == 0, do: "hidden"),
      show_plus: (if value == 29, do: "hidden"),
      target: target
    }
    ~L"""
    <tr>
      <td class="px-2 py-1 text-left"><%= @name %></td>
      <td class="px-1 py-1 hidden sm:table-cell"><%= @probe %></td>
      <td class="px-1 py-1 hidden sm:table-cell"><%= @sf %></td>
      <td class="pl-1 py-1">
        <button
          class='<%= @show_minus %> focus-none'
          phx-click='update_character'
          phx-value-t<%= @id %>='<%= @value - 1 %>'>
          <svg class='inline-block w-4 h-4 text-indigo-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 12H6" />
          </svg>
        </button>
      </td>
      <td class="px-0 py-1 text-center font-bold"><%= @value %></td>
      <td class="pr-1 py-1">
        <button
          class='<%= @show_plus %> focus-none'
          phx-click='update_character'
          phx-value-t<%= @id %>='<%= @value - 1 %>'>
          <svg class='inline-block w-4 h-4 text-indigo-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
        </button>
      </td>
      <td class="px-1 py-1">
        <button class='' phx-click='roll' phx-value-spell='<%= @id %>' phx-target='<%= @target %>'>
          <svg class='inline-block w-4 h-4 text-indigo-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
          </svg>
        </button>
      </td>
    </tr>
    """
  end
end
