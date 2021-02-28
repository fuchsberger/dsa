defmodule DsaWeb.SpellComponent do
  use DsaWeb, :live_component

  alias Dsa.Data.Spell
  alias Dsa.{Event}

  @group_id 1

  def render(assigns) do
    Phoenix.View.render DsaWeb.SpellView, "index.html", assigns
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
    traits = Enum.map(Spell.traits(spell_id), & Map.get(socket.assigns.character, &1))
    modifier = socket.assigns.modifier
    character_id = socket.assigns.character.id
    group_id = @group_id
    type = 5

    params = Dsa.Trial.handle_trial_event(traits, level, modifier, group_id, character_id, type, spell_id)

    case Event.create_log(params) do
      {:ok, log} ->
        broadcast({:log, Event.preload_character_name(log)})
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end
end
