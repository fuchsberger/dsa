defmodule DsaWeb.GroupLive do

  use Phoenix.LiveView

  import Ecto.Changeset, only: [get_field: 2]
  import Dsa.Data
  import DsaWeb.CharacterHelpers

  require Logger

  alias Dsa.{Event, Accounts, Repo}

  defp topic(group_id), do: "group:#{group_id}"

  def handle_info(%{event: "add-event", payload: event}, socket) do
    {:noreply, assign(socket, :logs, [event | socket.assigns.logs])}
  end

  def handle_info(%{event: "update-character", payload: character}, socket) do
    idx = Enum.find_index(socket.assigns.group.characters, & &1.id == character.id)
    characters =
      socket.assigns.group.characters
      |> List.replace_at(idx, character)
      |> Enum.sort_by(& {&1.ini && &1.ini * -1, &1.name})

    if socket.assigns.character.data.id == character.id do
      {:noreply, socket
      |> assign(:character, Accounts.change_character(character, %{}, :combat))
      |> assign(:group, Map.put(socket.assigns.group, :characters, characters))}
    else
      {:noreply, assign(socket, :group, Map.put(socket.assigns.group, :characters, characters))}
    end
  end

  def render(assigns), do: DsaWeb.GroupView.render("group.html", assigns)

  def mount(%{"id" => group_id}, %{"user_id" => user_id}, socket) do

    {logs, group} = get_initial_data(group_id)

    DsaWeb.Endpoint.subscribe(topic(group.id))

    # character changeset
    character =
      case Enum.find(group.characters, & &1.user_id == user_id) do
        nil -> nil
        character -> Accounts.change_character(character, %{}, :combat)
      end

    user_character_ids =
      group.characters
      |> Enum.filter(& &1.user_id == user_id)
      |> Enum.map(& &1.id)

    {:ok, socket
    |> assign(:armor_options, armors())
    |> assign(:group, group)
    |> assign(:logs, logs)
    |> assign(:character, character)
    |> assign(:settings, Event.change_settings())
    |> assign(:show_details, false)
    |> assign(:master?, group.master_id == user_id)
    |> assign(:user_id, user_id)
    |> assign(:user_character_ids, user_character_ids)}
  end

  def handle_params(_params, _session, socket) do
    {:noreply, socket}
  end

  def get_initial_data(group_id) do
    group = Accounts.get_group!(group_id)

    logs =
      group.trait_rolls ++ group.talent_rolls ++ group.general_rolls ++ group.routine
      |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})

    group = Map.drop(group, [:general_rolls, :trait_rolls, :talent_rolls, :routine])

    {logs, group}
  end

  def handle_event("change", %{"character" => params}, socket) do

    case Accounts.update_character(socket.assigns.character.data, params, :combat) do
      {:ok, character} ->
        character = Accounts.preload(character)
        Logger.debug("Character updated.")
        DsaWeb.Endpoint.broadcast(topic(character.group_id), "update-character", character)
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while changing character: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("select_character", %{"character" => %{"id" => id}}, socket) do
    character =
      socket.assigns.group.characters
      |> Enum.find(& &1.id == String.to_integer(id))
      |> Accounts.change_character(%{}, :combat)

    {:noreply, assign(socket, :character, character)}
  end

  def handle_event("toggle-details", _params, socket) do
    details = !socket.assigns.show_details
    Logger.debug("Show details: #{inspect(details)}")
    {:noreply, assign(socket, :show_details, details)}
  end

  def handle_event("validate", %{"setting" => setting}, socket) do
    Logger.debug("Changing Settings: #{inspect(setting)}")
    {:noreply, assign(socket, :settings, Event.change_settings(setting))}
  end

  def handle_event("quick-roll", _params, socket) do

    c = active_character(socket)
    count = get_field(socket.assigns.settings, :dice_count)
    max = get_field(socket.assigns.settings, :dice_type)

    params = %{
      character_id: c.id,
      group_id: c.group_id,
      d1: Enum.random(1..max),
      d2: (if count >= 2, do: Enum.random(1..max), else: nil),
      d3: (if count >= 3, do: Enum.random(1..max), else: nil),
      d4: (if count >= 4, do: Enum.random(1..max), else: nil),
      d5: (if count >= 5, do: Enum.random(1..max), else: nil),
      max: max,
      hidden: get_field(socket.assigns.settings, :hidden)
    }

    case Event.create_general_roll(params) do
      {:ok, roll} ->
        roll = Repo.preload(roll, :character)
        Logger.debug("Quickroll created.")
        DsaWeb.Endpoint.broadcast(topic(roll.group_id), "add-event", roll)
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while creating quick-roll: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("routine", %{"talent" => id}, socket) do
    c = active_character(socket)
    level = Map.get(c, String.to_atom("t#{id}"))

    params = %{
      fw: Kernel.trunc(level / 2),
      skill_id: String.to_integer(id),
      character_id: c.id,
      group_id: c.group_id
    }

    case Event.create_routine(params) do
      {:ok, routine} ->
        routine = Repo.preload(routine, [:character])
        Logger.debug("Routine created.")
        DsaWeb.Endpoint.broadcast(topic(routine.group_id), "add-event", routine)
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while creating routine: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("trait-roll", %{"trait" => trait}, socket) do
    c = active_character(socket)

    params = %{
      trait: trait,
      level: Map.get(c, String.to_atom(trait)),
      modifier: get_field(socket.assigns.settings, :modifier),
      w1: Enum.random(1..20),
      w1b: Enum.random(1..20),
      character_id: c.id,
      group_id: c.group_id
    }

    case Event.create_trait_roll(params) do
      {:ok, roll} ->
        roll = Repo.preload(roll, :character)
        Logger.debug("Trait roll created.")
        DsaWeb.Endpoint.broadcast(topic(roll.group_id), "add-event", roll)
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while creating trait-roll: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("talent-roll", %{"be" => be, "talent" => id}, socket) do
    id = String.to_integer(id)
    c = active_character(socket)
    [t1, t2, t3] = skill(id, :probe) |> probe_values(c)

    params = %{
      w1: Enum.random(1..20),
      w2: Enum.random(1..20),
      w3: Enum.random(1..20),
      modifier: get_field(socket.assigns.settings, :modifier),
      level: Map.get(c, String.to_atom("t#{id}")),
      t1: t1,
      t2: t2,
      t3: t3,
      be: (if be == "true", do: c.be, else: 0),
      skill_id: id,
      character_id: c.id,
      group_id: c.group_id
    }

    case Event.create_talent_roll(params) do
      {:ok, roll} ->
        roll = Repo.preload(roll, [:character])
        Logger.debug("Talent roll created.")
        DsaWeb.Endpoint.broadcast(topic(roll.group_id), "add-event", roll)
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while creating talent-roll: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("roll-ini", %{"ini" => ini}, socket) do
    ini = String.to_integer(ini) + Enum.random(1..6)
    case Accounts.update_character(socket.assigns.character.data, %{ini: ini}, :combat) do
      {:ok, character} ->
        character = Accounts.preload(character)
        Logger.debug("#{character.name} rolled initiative #{character.ini}")
        DsaWeb.Endpoint.broadcast(topic(character.group_id), "update-character", character)
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while changing character: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("reset-ini", _params, socket) do
    case Accounts.update_character(socket.assigns.character.data, %{ini: nil}, :combat) do
      {:ok, character} ->
        character = Accounts.preload(character)
        Logger.debug("#{character.name} left combat.")
        DsaWeb.Endpoint.broadcast(topic(character.group_id), "update-character", character)
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while changing character: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  defp active_character(socket) do
    Enum.find(socket.assigns.group.characters, & &1.id == get_field(socket.assigns.character, :id))
  end
end
