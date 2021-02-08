defmodule DsaWeb.SkillComponent do
  use DsaWeb, :live_component

  alias Dsa.Data.Skill
  alias Dsa.{Accounts, Event, Repo}

  import DsaWeb.DsaLive, only: [topic: 0]

  @group_id 1

  def render(assigns) do
    ~L"""
    <table class="w-full shadow-xl border-gray-200 rounded-lg text-sm divide-y divide-gray-200 text-center">
      <thead class="leading-8 text-gray-900 bg-gray-300 font-medium">
        <tr>
          <th scope="col" class="px-2 text-left">Talent</th>
          <th scope="col" class="px-1 hidden sm:table-cell">Probe</th>
          <th scope="col" class="px-1 hidden sm:table-cell">BE</th>
          <th scope="col" class="px-1 hidden sm:table-cell">SF</th>
          <th scope="col" colspan='3'>FW</th>
          <th scope="col">R</th>
          <th scope="col">P</th>
        </tr>
      </thead>
      <tbody class="bg-white divide-y divide-gray-200">
        <%= header_row("Körpertalente", "MU/GE/KK", "188-194", "48 AP") %>
        <%= for skill_id <- 1..14 do %><%= row(@myself, @character, skill_id) %><% end %>
        <%= header_row("Gesellschaftstalente", "IN/CH/CH", "194-198", "48 AP") %>
        <%= for skill_id <- 15..23 do %><%= row(@myself, @character, skill_id) %><% end %>
        <%= header_row("Naturtalente", "MU/GE/KO", "198-201", "48 AP") %>
        <%= for skill_id <- 24..30 do %><%= row(@myself, @character, skill_id) %><% end %>
        <%= header_row("Wissenstalente", "KL/KL/IN", "201-206", "48 AP") %>
        <%= for skill_id <- 31..42 do %><%= row(@myself, @character, skill_id) %><% end %>
        <%= header_row("Handwerkstalente", "FF/FF/KO", "206-213", "48 AP") %>
        <%= for skill_id <- 43..58 do %><%= row(@myself, @character, skill_id) %><% end %>
      </tbody>
    </table>
    """
  end

  def mount(socket), do: {:ok, socket}

  def update(%{character_id: id, modifier: modifier}, socket) do
    {:ok, socket
    |> assign(:character, Accounts.get_character(id, :skills))
    |> assign(:modifier, modifier)}
  end

  def handle_event("decrement", %{"skill" => id}, socket) do
    case Accounts.decrement_character_skill(socket.assigns.character, String.to_atom("t#{id}")) do
      {:ok, character} ->
        {:noreply, assign(socket, character: character)}

      {:error, changeset} ->
        Logger.error("Error occured while decrementing character skill: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("increment", %{"skill" => id}, socket) do
    case Accounts.increment_character_skill(socket.assigns.character, String.to_atom("t#{id}")) do
      {:ok, character} ->
        {:noreply, assign(socket, character: character)}

      {:error, changeset} ->
        Logger.error("Error occured while incrementing character skill: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("roll", %{"skill" => id}, socket) do

    skill_id = String.to_integer(id)

    [trait_1, trait_2, trait_3] =
      skill_id
      |> Skill.probe()
      |> traits()

    trait_value_1 = Map.get(socket.assigns.character, trait_1)
    trait_value_2 = Map.get(socket.assigns.character, trait_2)
    trait_value_3 = Map.get(socket.assigns.character, trait_3)

    dice_1 = Enum.random(1..20)
    dice_2 = Enum.random(1..20)
    dice_3 = Enum.random(1..20)

    modifier = socket.assigns.modifier
    skill_value = Map.get(socket.assigns.character, String.to_atom("t#{id}"))

    result =
      cond do
        Enum.count([dice_1, dice_2, dice_3], & &1 == 1) >= 2 -> 10 # critical success
        Enum.count([dice_1, dice_2, dice_3], & &1 == 20) >= 2 -> -2 # critical failure
        true ->
          # count spent tw
          remaining =
            skill_value
            - max(dice_1 - trait_value_1 - modifier, 0)
            - max(dice_2 - trait_value_2 - modifier, 0)
            - max(dice_3 - trait_value_3 - modifier, 0)

          cond do
            remaining < 0 -> -1 # normal failure
            true -> div(remaining, 3) + 1 # normal success => show quality
          end
      end

    params =
      %{
        type: 4,
        x1: skill_id,
        x2: nil,
        x3: nil,
        x4: trait_value_1,
        x5: trait_value_2,
        x6: trait_value_3,
        x7: dice_1,
        x8: dice_2,
        x9: dice_3,
        x10: modifier,
        x11: skill_value,
        x12: result,
        character_id: socket.assigns.character.id,
        group_id: @group_id
      }

    case Event.create_log(params) do
      {:ok, log} ->
        Phoenix.PubSub.broadcast!(Dsa.PubSub, topic(), {:log, Event.preload_character_name(log)})
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
      <th colspan='3' scope="row"><%= @ap %></th>
      <th scope="row" class="px-1" colspan='2'>
        <svg class='inline-block w-4 h-4' viewBox="0 0 20 20" fill="currentColor">
          <path d="M11 17a1 1 0 001.447.894l4-2A1 1 0 0017 15V9.236a1 1 0 00-1.447-.894l-4 2a1 1 0 00-.553.894V17zM15.211 6.276a1 1 0 000-1.788l-4.764-2.382a1 1 0 00-.894 0L4.789 4.488a1 1 0 000 1.788l4.764 2.382a1 1 0 00.894 0l4.764-2.382zM4.447 8.342A1 1 0 003 9.236V15a1 1 0 00.553.894l4 2A1 1 0 009 17v-5.764a1 1 0 00-.553-.894l-4-2z" />
        </svg>
      </th>
    </tr>
    """
  end

  defp row(target, character, skill_id) do
    value = Map.get(character, String.to_atom("t#{skill_id}"))

    assigns = %{
      id: skill_id,
      name: Skill.name(skill_id),
      probe: Skill.probe(skill_id),
      be: be(Skill.be(skill_id)),
      sf: Skill.sf(skill_id),
      value: value,
      show_minus: (if value == 0, do: "hidden"),
      show_plus: (if value == 29, do: "hidden"),
      target: target
    }
    ~L"""
    <tr>
      <td class="px-2 py-1 text-left"><%= @name %></td>
      <td class="px-1 py-1 hidden sm:table-cell"><%= @probe %></td>
      <td class="px-1 py-1 hidden sm:table-cell"><%= @be %></td>
      <td class="px-1 py-1 hidden sm:table-cell"><%= @sf %></td>
      <td class="pl-1 py-1 hidden sm:table-cell">
        <button class='<%= @show_minus %> focus-none' phx-click='decrement' phx-value-skill='<%= @id %>' phx-target='<%= @target %>'>
          <svg class='inline-block w-4 h-4 text-indigo-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 12H6" />
          </svg>
        </button>
      </td>
      <td class="px-0 py-1 text-center font-bold"><%= @value %></td>
      <td class="pr-1 py-1 hidden sm:table-cell">
        <button class='<%= @show_plus %>' phx-click='increment' phx-value-skill='<%= @id %>' phx-target='<%= @target %>'>
          <svg class='inline-block w-4 h-4 text-indigo-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
        </button>
      </td>
      <td class="px-1 py-1">
        <button class='hidden' phx-click='increment' phx-value-skill='<%= @id %>' phx-target='<%= @target %>'>
          <svg class='inline-block w-4 h-4 text-indigo-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 10l-2 1m0 0l-2-1m2 1v2.5M20 7l-2 1m2-1l-2-1m2 1v2.5M14 4l-2-1-2 1M4 7l2-1M4 7l2 1M4 7v2.5M12 21l-2-1m2 1l2-1m-2 1v-2.5M6 18l-2-1v-2.5M18 18l2-1v-2.5" />
          </svg>
        </button>
        -
      </td>
      <td class="px-1 py-1">
        <button class='' phx-click='roll' phx-value-skill='<%= @id %>' phx-target='<%= @target %>'>
          <svg class='inline-block w-4 h-4 text-indigo-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
          </svg>
        </button>
      </td>
    </tr>
    """
  end
end
