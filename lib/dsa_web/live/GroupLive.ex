defmodule DsaWeb.GroupLive do

  use Phoenix.LiveView

  import Ecto.Changeset, only: [get_field: 2]

  require Logger

  alias Dsa.{Event, Accounts, Repo}
  alias Dsa.Event.{GeneralRoll, TalentRoll, TraitRoll}

  defp topic(group_id), do: "group:#{group_id}"

  def handle_info(%{event: "add-event", payload: event}, socket) do
    {:noreply, assign(socket, :logs, [event | socket.assigns.logs])}
  end

  def render(assigns), do: DsaWeb.GroupView.render("group.html", assigns)

  def mount(%{"id" => group_id}, %{"user_id" => user_id}, socket) do

    {logs, group} = get_initial_data(group_id)

    character = Enum.find(group.characters, & &1.user_id == user_id)

    DsaWeb.Endpoint.subscribe(topic(group.id))

    {:ok, socket
    |> assign(:action, "Probe")
    |> assign(:roll_type, "Eigenschaften")
    |> assign(:group, group)
    |> assign(:logs, logs)
    |> assign(:show_details, false)
    |> assign(:settings, Event.change_settings(%{character_id: character && character.id}))
    |> assign(:user_id, user_id)}
  end

  def get_initial_data(group_id) do
    group = Accounts.get_group!(group_id)

    logs =
      group.trait_rolls ++ group.talent_rolls ++ group.general_rolls ++ group.routine
      |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})

    group = Map.drop(group, [:general_rolls, :trait_rolls, :talent_rolls, :routine])

    {logs, group}
  end

  def handle_event("prepare", %{"talent" => id}, socket) do
    c = active_character(socket)
    cskill = Enum.find(c.character_skills, & &1.skill_id == String.to_integer(id))

    params = %{
      skill_id: cskill.skill_id,
      e1: cskill.skill.e1,
      e2: cskill.skill.e2,
      e3: cskill.skill.e3,
      t1: Map.get(c, String.to_atom(cskill.skill.e1)),
      t2: Map.get(c, String.to_atom(cskill.skill.e2)),
      t3: Map.get(c, String.to_atom(cskill.skill.e3)),
      use_be: cskill.skill.be
    }

    {:noreply, socket}
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

  def handle_event("routine", %{"talent" => skill_id}, socket) do
    c = active_character(socket)
    cskill = Enum.find(c.character_skills, & &1.skill.id == String.to_integer(skill_id))

    params = %{
      fw: Kernel.trunc(cskill.level / 2),
      skill_id: cskill.skill.id,
      character_id: c.id,
      group_id: c.group_id
    }

    case Event.create_routine(params) do
      {:ok, routine} ->
        routine = Repo.preload(routine, [:character, :skill])
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
    c = active_character(socket)
    cskill = Enum.find(c.character_skills, & &1.skill_id == String.to_integer(id))
    e1 = cskill.skill.e1
    e2 = cskill.skill.e2
    e3 = cskill.skill.e3

    params = %{
      "w1" => Enum.random(1..20),
      "w2" => Enum.random(1..20),
      "w3" => Enum.random(1..20),
      "modifier" => get_field(socket.assigns.settings, :modifier),
      "level" => cskill.level,
      "t1" => Map.get(c, String.to_atom(e1)),
      "t2" => Map.get(c, String.to_atom(e2)),
      "t3" => Map.get(c, String.to_atom(e3)),
      "e1" => e1,
      "e2" => e2,
      "e3" => e3,
      "be" => (if be == "true", do: c.be, else: 0),
      "skill_id" => cskill.skill.id,
      "character_id" => c.id,
      "group_id" => c.group_id
    }

    case Event.create_talent_roll(params) do
      {:ok, roll} ->
        roll = Repo.preload(roll, [:character, :skill])
        Logger.debug("Talent roll created.")
        DsaWeb.Endpoint.broadcast(topic(roll.group_id), "add-event", roll)
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error("Error occured while creating talent-roll: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  defp active_character(socket) do
    Enum.find(socket.assigns.group.characters, & &1.id == get_field(socket.assigns.settings, :character_id))
  end
end
