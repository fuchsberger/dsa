defmodule DsaWeb.GroupLive do

  use Phoenix.LiveView

  alias Ecto.Changeset
  alias Dsa.{Event, Game}
  alias Dsa.Event.TraitRoll

  def render(assigns), do: DsaWeb.GroupView.render("group.html", assigns)

  def mount(%{"id" => id}, %{"user_id" => user_id}, socket) do
    group = Game.get_group!(id)
    active_id = Enum.find(group.characters, & &1.user_id == user_id).id

    {:ok, socket
    |> assign(:changeset_active_character, Game.change_active_character(%{id: active_id}))
    # |> assign(:changeset_talent_roll, Game.change_talent_roll())
    # |> assign(:changeset_trait_roll, Event.change_trait_roll())
    |> assign(:changeset_roll, nil)
    |> assign(:group, group)
    |> assign(:show_details, false)
    |> assign(:user_id, user_id)}
  end

  def handle_event("activate", %{"character" => params}, socket) do
    {:noreply, assign(socket, :changeset_active_character, Game.change_active_character(params))}
  end

  def handle_event("toggle", %{"log" => _params}, socket) do
    {:noreply, assign(socket, :show_details, !socket.assigns.show_details)}
  end

  def handle_event("validate", %{"talent_roll" => params}, socket) do
    {:noreply, assign(socket, :changeset_talent_roll, Game.change_talent_roll(params))}
  end

  def handle_event("validate", %{"trait_roll" => params}, socket) do
    {:noreply, assign(socket, :changeset_roll, Event.change_trait_roll(%TraitRoll{}, params))}
  end

  def handle_event("prepare", params, socket) do
    {:noreply, assign(socket, :changeset_roll, Event.change_trait_roll(%TraitRoll{}, params))}
  end

  def handle_event("event", %{"talent_roll" => %{"skill_id" => sid, "modifier" => modifier}}, socket) do

    [sid, modifier] = Enum.map([sid, modifier], & String.to_integer(&1))
    character = active_character(socket)
    cskill = Enum.find(character.character_skills, & &1.skill_id == sid)
    skill = cskill.skill

    [w1, w2, w3] = [Enum.random(1..20), Enum.random(1..20), Enum.random(1..20)]
    [t1, t2, t3] = Enum.map([:e1, :e2, :e3], & skill_value(character, skill, &1))

    result = cskill.level - max(0, w1 - t1 - modifier) - max(0, w2 - t2 - modifier) - max(0, w3 - t3 - modifier)

    message =
      case quality(w1, w2, w3, result) do
        8 ->
          "#{character.name} hat eine Probe auf #{skill.name} (#{modifier}) spektakulär gemeistert. Unglaublich, die Chanchen standen 1:8000!"
        7 ->
          "#{character.name} hat bei einer Probe auf #{skill.name} (#{modifier}) einen kritischen Erfolg erzielt."
        -2 ->
          "#{character.name} ist eine Probe auf #{skill.name} (#{modifier}) schrecklich misslungen. Unglaublich, die Chanchen standen 1:8000!"
        -1 ->
          "#{character.name} ist eine Probe auf #{skill.name} (#{modifier}) kritisch missglückt."
        0 ->
          "#{character.name} ist eine Probe auf #{skill.name} (#{modifier}) missglückt."

        quality ->
          "#{character.name} hat erfolgreich eine Probe auf #{skill.name} (#{modifier}) bestanden (Qualität #{quality})."
      end

    details =
      "Würfel: #{w1}/#{w2}/#{w3} | Probe: #{skill.e1}/#{skill.e2}/#{skill.e3} (#{t1}/#{t2}/#{t3}) | Übrige FP: #{result}"

    params = %{
      character_id: character.id,
      group_id: socket.assigns.group.id,
      message: message,
      details: details
    }

    case Game.create_log(params) do
      {:ok, %{group_id: id}} -> {:noreply, assign(socket, :group, Game.get_group!(id))}
      {:error, _changeset} -> {:noreply, socket}
    end
  end

  def handle_event("event", %{"trait_roll" => %{"trait" => trait} = params}, socket) do

    character = active_character(socket)

    params = Map.merge(params, %{
      "w1" => Enum.random(1..20),
      "w1b" => Enum.random(1..20),
      "level" => Map.get(character, String.to_atom(trait)),
      "max_be" => character.be,
      "character_id" => socket.assigns.changeset_active_character.changes.id,
      "group_id" => socket.assigns.group.id
    })

    case Event.create_trait_roll(params) do
      {:ok, _roll} ->
        {:noreply, socket
        |> assign(:changeset_roll, nil)
        |> assign(:group, Game.get_group!(socket.assigns.group.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset_roll, changeset)}
    end
  end

  def handle_event("delete", %{"trait_roll" => id}, socket) do
    socket.assigns.group.trait_rolls
    |> Enum.find(& &1.id == String.to_integer(id))
    |> Event.delete_roll!()

    {:noreply, assign(socket, :group, Game.get_group!(socket.assigns.group.id))}
  end

  defp active_character(socket) do
    id = socket.assigns.changeset_active_character.changes.id
    Enum.find(socket.assigns.group.characters, & &1.id == id)
  end

  defp quality(w1, w2, w3, result) do
    cond do
      w1 == 1 && w2 == 1 && w3 == 1 -> 8
      w1 == 1 && w2 == 1 -> 7
      w1 == 1 && w3 == 1 -> 7
      w2 == 1 && w3 == 1 -> 7
      w1 == 20 && w2 == 20 && w3 == 20 -> -2
      w1 == 20 && w2 == 20 -> -1
      w1 == 20 && w3 == 20 -> -1
      w2 == 20 && w3 == 20 -> -1
      result >= 16 -> 6
      result >= 13 -> 5
      result >= 10 -> 4
      result >= 7 -> 3
      result >= 4 -> 2
      result >= 0 -> 1
      result < 0 -> 0
    end
  end

  defp skill_value(character, skill, trait) do
    skill = skill |> Map.get(trait) |> String.downcase() |> String.to_atom()
    Map.get(character, skill)
  end
end
