defmodule DsaWeb.SkillComponent do
  use DsaWeb, :live_component

  alias Dsa.Data.Skill
  alias Dsa.{Accounts, Repo}

  def render(assigns) do
    ~L"""
    <table class="w-full shadow-xl  border-gray-200 rounded-lg text-sm divide-y divide-gray-200 text-center">
      <thead class="leading-8 text-gray-900 bg-gray-300 font-medium">
        <tr>
          <th scope="col" class="px-2 text-left">Talent</th>
          <th scope="col" class="px-1 hidden sm:table-cell">Probe</th>
          <th scope="col" class="px-1 hidden sm:table-cell">BE</th>
          <th scope="col" class="px-1 hidden sm:table-cell">SF</th>
          <th scope="col" colspan='3'>FW</th>
          <th scope="col" colspan='2' class="px-1">Probe</th>
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

  def update(%{character_id: id}, socket) do
    {:ok, assign(socket, :character, Accounts.get_character(id, :skills))}
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

  defp header_row(category, probe, pages, ap) do
    assigns = %{category: category, probe: probe, ap: ap, pages: pages}
    ~L"""
    <tr>
      <th scope="row" class="px-2 text-left text-base"><%= @category %></th>
      <th scope="row" class="hidden sm:table-cell px-0"><%= @probe %></th>
      <th colspan='2' scope="row" class="px-1 hidden sm:table-cell"><%= @pages %></th>
      <th colspan='3' scope="row"><%= @ap %></th>
      <th colspan='2' scope="row" class="px-1"></th>
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
          <svg class='inline-block w-4 h-4 text-red-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 12H6" />
          </svg>
        </button>
      </td>
      <td class="px-0 py-1 text-center font-bold"><%= @value %></td>
      <td class="pr-1 py-1 hidden sm:table-cell">
        <button class='<%= @show_plus %>' phx-click='increment' phx-value-skill='<%= @id %>' phx-target='<%= @target %>'>
          <svg class='inline-block w-4 h-4 text-green-600' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
        </button>
      </td>
      <td class="px-1 py-1 hidden sm:table-cell">+3</td>
      <td class="px-1 py-1"></td>
    </tr>
    """
  end
end
