defmodule DsaWeb.GroupLive do

  use Phoenix.LiveView

  alias Dsa.{Event, Accounts}
  alias Dsa.Event.{GeneralRoll, TalentRoll, TraitRoll}

  def render(assigns), do: DsaWeb.GroupView.render("group.html", assigns)

  def mount(%{"id" => id}, %{"user_id" => user_id}, socket) do
    group = Accounts.get_group!(id)
    active_id = Enum.find(group.characters, & &1.user_id == user_id).id

    {:ok, socket
    |> assign(:changeset_active_character, Accounts.change_active_character(%{id: active_id}))
    |> assign(:changeset_roll, Event.change_roll(%GeneralRoll{}, %{}))
    |> assign(:group, group)
    |> assign(:show_details, false)
    |> assign(:user_id, user_id)}
  end

  def handle_event("activate", %{"character" => params}, socket) do
    {:noreply, assign(socket, :changeset_active_character, Accounts.change_active_character(params))}
  end

  def handle_event("prepare", %{"trait" => trait}, socket) do
    c = active_character(socket)
    params = %{trait: trait, level: Map.get(c, String.to_atom(trait))}
    {:noreply, assign(socket, :changeset_roll, Event.change_roll(%TraitRoll{}, params))}
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

    {:noreply, assign(socket, :changeset_roll, Event.change_roll(%TalentRoll{}, params))}
  end

  def handle_event("toggle", %{"log" => _params}, socket) do
    {:noreply, assign(socket, :show_details, !socket.assigns.show_details)}
  end

  def handle_event("validate", %{"general_roll" => params}, socket) do
    {:noreply, assign(socket, :changeset_roll, Event.change_roll(%GeneralRoll{}, params))}
  end

  def handle_event("validate", %{"trait_roll" => params}, socket) do
    c = active_character(socket)
    params = Map.merge(params, %{"level" => Map.get(c, String.to_atom(params["trait"]))})
    {:noreply, assign(socket, :changeset_roll, Event.change_roll(%TraitRoll{}, params))}
  end

  def handle_event("validate", %{"talent_roll" => params}, socket) do
    c = active_character(socket)

    params = Map.merge(params, %{
      "t1" => Map.get(c, String.to_atom(params["e1"])),
      "t2" => Map.get(c, String.to_atom(params["e2"])),
      "t3" => Map.get(c, String.to_atom(params["e3"])),
    })
    {:noreply, assign(socket, :changeset_roll, Event.change_roll(%TalentRoll{}, params))}
  end

  def handle_event("event", %{"general_roll" => %{"count" => count, "max" => max, "bonus" => bonus} =  params}, socket) do
    c = active_character(socket)
    count = String.to_integer(count)
    max = String.to_integer(max)
    bonus = String.to_integer(bonus)

    params = Map.merge(params, %{
      "result" => bonus + Enum.reduce(1..count, 0, fn _x, acc -> acc + Enum.random(1..max) end),
      "character_id" => c.id,
      "group_id" => c.group_id
    })

    case Event.create_general_roll(params) do
      {:ok, _roll} ->
        {:noreply, socket
        |> assign(:changeset_roll, Event.change_roll(%GeneralRoll{}, %{}))
        |> assign(:group, Accounts.get_group!(socket.assigns.group.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset_roll, changeset)}
    end
  end

  def handle_event("event", %{"talent_roll" => params}, socket) do
    c = active_character(socket)
    cskill = Enum.find(c.character_skills, & &1.skill_id == String.to_integer(params["skill_id"]))

    params = Map.merge(params, %{
      "w1" => Enum.random(1..20),
      "w2" => Enum.random(1..20),
      "w3" => Enum.random(1..20),
      "level" => cskill.level,
      "e1" => cskill.skill.e1,
      "e2" => cskill.skill.e2,
      "e3" => cskill.skill.e3,
      "be" => (if params["use_be"] == "true", do: c.be, else: 0),
      "character_id" => c.id,
      "group_id" => c.group_id
    })

    case Event.create_talent_roll(params) do
      {:ok, _roll} ->
        {:noreply, socket
        |> assign(:changeset_roll, Event.change_roll(%GeneralRoll{}, %{}))
        |> assign(:group, Accounts.get_group!(socket.assigns.group.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset_roll, changeset)}
    end
  end

  def handle_event("event", %{"trait_roll" => %{"trait" => _} = params}, socket) do
    c = active_character(socket)

    params = Map.merge(params, %{
      "w1" => Enum.random(1..20),
      "w1b" => Enum.random(1..20),
      "be" => (if params["use_be"] == "true", do: c.be, else: 0),
      "character_id" => c.id,
      "group_id" => c.group_id
    })

    case Event.create_trait_roll(params) do
      {:ok, _roll} ->
        {:noreply, socket
        |> assign(:changeset_roll, Event.change_roll(%GeneralRoll{}, %{}))
        |> assign(:group, Accounts.get_group!(socket.assigns.group.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset_roll, changeset)}
    end
  end

  def handle_event("delete", %{"general_roll" => id}, socket) do
    socket.assigns.group.general_rolls
    |> Enum.find(& &1.id == String.to_integer(id))
    |> Event.delete_roll!()

    {:noreply, assign(socket, :group, Accounts.get_group!(socket.assigns.group.id))}
  end

  def handle_event("delete", %{"trait_roll" => id}, socket) do
    socket.assigns.group.trait_rolls
    |> Enum.find(& &1.id == String.to_integer(id))
    |> Event.delete_roll!()

    {:noreply, assign(socket, :group, Accounts.get_group!(socket.assigns.group.id))}
  end

  def handle_event("delete", %{"talent_roll" => id}, socket) do
    socket.assigns.group.talent_rolls
    |> Enum.find(& &1.id == String.to_integer(id))
    |> Event.delete_roll!()

    {:noreply, assign(socket, :group, Accounts.get_group!(socket.assigns.group.id))}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :changeset_roll, Event.change_roll(%GeneralRoll{}, %{}))}
  end

  defp active_character(socket) do
    id = socket.assigns.changeset_active_character.changes.id
    Enum.find(socket.assigns.group.characters, & &1.id == id)
  end
end
