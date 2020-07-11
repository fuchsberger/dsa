defmodule DsaWeb.GroupLive do

  use Phoenix.LiveView
  alias Dsa.Game

  def render(assigns), do: DsaWeb.GroupView.render("group_live.html", assigns)

  def mount(%{"id" => id}, %{"user_id" => user_id}, socket) do
    group = Game.get_group!(id)

    {:ok, socket
    |> assign(:active_id, Enum.find(group.characters, & &1.user_id == user_id).id)
    |> assign(:changeset_talent_roll, Game.change_talent_roll())
    |> assign(:group, group)
    |> assign(:user_id, user_id)}
  end

  def handle_event("activate", %{"character" => id}, socket) do
    {:noreply, assign(socket, :active_id, String.to_integer(id))}
  end

  def handle_event("validate", %{"talent_roll" => params}, socket) do
    {:noreply, assign(socket, :changeset_talent_roll, Game.change_talent_roll(params))}
  end

  def handle_event("event", %{"talent_roll" => %{"skill_id" => sid, "modifier" => modifier}}, socket) do

    [sid, modifier] = Enum.map([sid, modifier], & String.to_integer(&1))
    character = Enum.find(socket.assigns.group.characters, & &1.id == socket.assigns.active_id)
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
          "#{character.name} ist eine Probe auf #{skill.name} (#{modifier}) schrecklich misslungen.Unglaublich, die Chanchen standen 1:8000!"
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
