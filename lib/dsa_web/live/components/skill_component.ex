defmodule DsaWeb.SkillComponent do
  use DsaWeb, :live_component

  alias Dsa.Data.Skill
  alias Dsa.{Accounts, Event, Repo}

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
        <%= for skill_id <- 43..59 do %><%= row(@myself, @character, skill_id) %><% end %>
      </tbody>
    </table>
    """
  end

  def mount(socket), do: {:ok, socket}

  def handle_event("update", params, socket) do
    Accounts.update_character!(socket.assigns.character, params)
    broadcast(:update_user)
    {:noreply, socket}
  end

  def handle_event("roll", %{"skill" => id}, socket) do

    skill_id = String.to_integer(id)

    d1 = Enum.random(1..20)
    d2 = Enum.random(1..20)
    d3 = Enum.random(1..20)

    params =
      %{
        type: 4,
        x1: skill_id,
        x7: d1,
        x8: d2,
        x9: d3,
        x10: socket.assigns.modifier,
        x12: result(socket.assigns.character, skill_id, socket.assigns.modifier, d1, d2, d3),
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

  def result(character, skill_id, mod, d1, d2, d3) do
    cond do
      Enum.count([d1, d2, d3], & &1 == 1) >= 2 -> 10 # critical success
      Enum.count([d1, d2, d3], & &1 == 20) >= 2 -> -2 # critical failure
      true ->
        skill = Map.get(character, Skill.field(skill_id))
        [t1, t2, t3] = Enum.map(Skill.traits(skill_id), & Map.get(character, &1))

        # count spent tw
        remaining = skill - max(d1 - t1 - mod, 0) - max(d2 - t2 - mod, 0) - max(d3 - t3 - mod, 0)

        cond do
          remaining < 0 -> -1 # normal failure
          true -> div(remaining, 3) + 1 # normal success => show quality
        end
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
      <th scope="row" class="px-1">
        <svg class='inline-block w-4 h-4' viewBox="0 0 20 20" fill="currentColor">
          <path d="M11 17a1 1 0 001.447.894l4-2A1 1 0 0017 15V9.236a1 1 0 00-1.447-.894l-4 2a1 1 0 00-.553.894V17zM15.211 6.276a1 1 0 000-1.788l-4.764-2.382a1 1 0 00-.894 0L4.789 4.488a1 1 0 000 1.788l4.764 2.382a1 1 0 00.894 0l4.764-2.382zM4.447 8.342A1 1 0 003 9.236V15a1 1 0 00.553.894l4 2A1 1 0 009 17v-5.764a1 1 0 00-.553-.894l-4-2z" />
        </svg>
      </th>
    </tr>
    """
  end

  defp row(target, skill_values, skill_id) do
    field = Skill.field(skill_id)
    value = Map.get(skill_values, field)

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
      <td class="pl-1 py-1">
        <button
          class='<%= @show_minus %> focus-none'
          phx-click='update'
          phx-value-t<%= @id %>='<%= @value - 1 %>'
          phx-target='<%= @target %>'>
          <svg class='inline-block w-4 h-4 text-indigo-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 12H6" />
          </svg>
        </button>
      </td>
      <td class="px-0 py-1 text-center font-bold"><%= @value %></td>
      <td class="pr-1 py-1">
        <button
          class='<%= @show_plus %> focus-none'
          phx-click='update'
          phx-value-t<%= @id %>='<%= @value + 1 %>'
          phx-target='<%= @target %>'>
          <svg class='inline-block w-4 h-4 text-indigo-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
        </button>
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
