defmodule DsaWeb.GroupLive do

  use Phoenix.LiveView

  import Ecto.Changeset, only: [get_field: 2]
  import Dsa.Data
  import DsaWeb.CharacterHelpers
  import DsaWeb.GroupView
  import Dsa.Lists

  require Logger

  alias Dsa.{Event, Accounts, Repo}

  defp topic(group_id), do: "group:#{group_id}"

  def handle_info(%{event: "log", payload: log}, socket) do
    {:noreply, assign(socket, :logs, [log | socket.assigns.logs])}
  end

  def handle_info(%{event: "update-character", payload: character}, socket) do
    idx = Enum.find_index(socket.assigns.group.characters, & &1.id == character.id)
    characters =
      socket.assigns.group.characters
      |> List.replace_at(idx, character)
      |> Enum.sort_by(& {&1.ini && &1.ini * -1, &1.name})

    if socket.assigns.changeset.data.id == character.id do
      {:noreply, socket
      |> assign(:changeset, Accounts.change_character(character, %{}, :combat))
      |> assign(:group, Map.put(socket.assigns.group, :characters, characters))}
    else
      {:noreply, assign(socket, :group, Map.put(socket.assigns.group, :characters, characters))}
    end
  end

  def render(assigns), do: DsaWeb.GroupView.render("group.html", assigns)

  def mount(%{"id" => group_id}, %{"user_id" => user_id}, socket) do

    group = Accounts.get_group!(group_id)
    DsaWeb.Endpoint.subscribe(topic(group.id))

    c = Enum.find(group.characters, & &1.user_id == user_id)

    user_character_ids =
      group.characters
      |> Enum.filter(& &1.user_id == user_id)
      |> Enum.map(& &1.id)

    {:ok, socket
    |> assign(:armor_options, (unless is_nil(c), do: Dsa.Data.Armor.options(c), else: []))

    |> assign(:logs, group.logs)
    |> assign(:group, Map.delete(group, :logs))
    |> assign(:changeset, (unless is_nil(c), do: Accounts.change_character(c, %{}, :combat), else: nil))
    |> assign(:settings, Event.change_settings())
    |> assign(:show_details, false)
    |> assign(:master?, group.master_id == user_id)
    |> assign(:user_id, user_id)
    |> assign(:user_character_ids, user_character_ids)}
  end

  def handle_params(_params, _session, socket) do
    {:noreply, socket}
  end

  def handle_event("change", %{"character" => params}, socket) do

    case Accounts.update_character(socket.assigns.changeset.data, params, :combat) do
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
    changeset =
      socket.assigns.group.characters
      |> Enum.find(& &1.id == String.to_integer(id))
      |> Accounts.change_character(%{}, :combat)

    {:noreply, assign(socket, :changeset, changeset)}
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
      type: 1,
      x1: Enum.random(1..max),
      x2: (if count >= 2, do: Enum.random(1..max), else: nil),
      x3: (if count >= 3, do: Enum.random(1..max), else: nil),
      x4: (if count >= 4, do: Enum.random(1..max), else: nil),
      x5: (if count >= 5, do: Enum.random(1..max), else: nil),
      x6: (if count >= 6, do: Enum.random(1..max), else: nil),
      x7: (if count >= 7, do: Enum.random(1..max), else: nil),
      x8: (if count >= 8, do: Enum.random(1..max), else: nil),
      x9: (if count >= 9, do: Enum.random(1..max), else: nil),
      x10: (if count >= 10, do: Enum.random(1..max), else: nil),
      x11: max,
      x12: (if get_field(socket.assigns.settings, :hidden), do: 1, else: nil),
      character_id: c.id,
      group_id: c.group_id,
    }

    case Event.create_log(params) do
      {:ok, log} ->
        Logger.debug("Quickroll created.")
        DsaWeb.Endpoint.broadcast(topic(log.group_id), "log", Repo.preload(log, :character))
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

  def handle_event("base-roll", %{"trait" => trait}, socket) do
    c = active_character(socket)
    trait = String.to_atom(trait)

    params = %{
      type: 2,
      x1: Enum.find_index(base_values(), & &1 == trait),  # base value id
      x2: Map.get(c, trait),                              # level
      x3: get_field(socket.assigns.settings, :modifier),  # modifier
      x4: Enum.random(1..20),                             # roll
      x5: Enum.random(1..20),                             # roll confirmation
      character_id: c.id,
      group_id: c.group_id
    }

    case Event.create_log(params) do
      {:ok, log} ->
        Logger.debug("Base roll created.")
        DsaWeb.Endpoint.broadcast(topic(log.group_id), "log", Repo.preload(log, :character))
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while creating trait-roll: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("talent-roll", %{"be" => be, "talent" => id}, socket) do
    id = String.to_integer(id)
    c = active_character(socket)
    [b1, b2, b3] = base_value_indexes(skill(id, :probe))

    params = %{
      type: 3,
      x1: Enum.random(1..20),                             # w1
      x2: Enum.random(1..20),                             # w2
      x3: Enum.random(1..20),                             # w3
      x4: get_field(socket.assigns.settings, :modifier),  # modifier
      x5: Map.get(c, String.to_atom("t#{id}")),           # level
      x6: base_value(c, b1),                              # t1
      x7: base_value(c, b2),                              # t2
      x8: base_value(c, b3),                              # t3
      x9: (if be == "true", do: c.be, else: 0),           # be
      x10: id,                                            # skill_id
      character_id: c.id,
      group_id: c.group_id
    }

    case Event.create_log(params) do
      {:ok, log} ->
        Logger.debug("Talent roll created.")
        DsaWeb.Endpoint.broadcast(topic(log.group_id), "log", Repo.preload(log, [:character]))
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while creating talent-roll: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("roll-ini", _params, socket) do
    ini = ini(socket.assigns.changeset.data).total + Enum.random(1..6)
    case Accounts.update_character(socket.assigns.changeset.data, %{ini: ini}, :combat) do
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
    case Accounts.update_character(socket.assigns.changeset.data, %{ini: nil}, :combat) do
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
    Enum.find(socket.assigns.group.characters, & &1.id == get_field(socket.assigns.changeset, :id))
  end
end
