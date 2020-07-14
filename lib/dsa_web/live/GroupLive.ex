defmodule DsaWeb.GroupLive do

  use Phoenix.LiveView

  alias Dsa.{Event, Accounts}
  alias Dsa.Event.{TalentRoll, TraitRoll}

  def render(assigns), do: DsaWeb.GroupView.render("group.html", assigns)

  def mount(%{"id" => id}, %{"user_id" => user_id}, socket) do
    group = Accounts.get_group!(id)
    active_id = Enum.find(group.characters, & &1.user_id == user_id).id

    {:ok, socket
    |> assign(:changeset_active_character, Accounts.change_active_character(%{id: active_id}))
    |> assign(:changeset_roll, nil)
    |> assign(:group, group)
    |> assign(:show_details, false)
    |> assign(:user_id, user_id)}
  end

  def handle_event("activate", %{"character" => params}, socket) do
    {:noreply, assign(socket, :changeset_active_character, Accounts.change_active_character(params))}
  end

  def handle_event("prepare", %{"trait" => _} = params, socket) do
    {:noreply, assign(socket, :changeset_roll, Event.change_roll(%TraitRoll{}, params))}
  end

  def handle_event("prepare", %{"talent" => _} = params, socket) do
    {:noreply, assign(socket, :changeset_roll, Event.change_roll(%TalentRoll{}, params))}
  end

  def handle_event("toggle", %{"log" => _params}, socket) do
    {:noreply, assign(socket, :show_details, !socket.assigns.show_details)}
  end

  def handle_event("validate", %{"trait_roll" => params}, socket) do
    {:noreply, assign(socket, :changeset_roll, Event.change_roll(%TraitRoll{}, params))}
  end

  def handle_event("validate", %{"talent_roll" => params}, socket) do
    character = active_character(socket)

    params = Map.merge(params, %{
      "e1" => Map.get(character, String.to_atom(params["t1"])),
      "e2" => Map.get(character, String.to_atom(params["t2"])),
      "e3" => Map.get(character, String.to_atom(params["t3"]))
    })

    {:noreply, assign(socket, :changeset_roll, Event.change_roll(%TalentRoll{}, params))}
  end

  def handle_event("event", %{"talent_roll" => params}, socket) do

    character = active_character(socket)

    params = Map.merge(params, %{
      "w1" => Enum.random(1..20),
      "w2" => Enum.random(1..20),
      "w3" => Enum.random(1..20),
      "level" => Map.get(character, String.to_atom(params["talent"])),
      "e1" => Map.get(character, String.to_atom(params["t1"])),
      "e2" => Map.get(character, String.to_atom(params["t2"])),
      "e3" => Map.get(character, String.to_atom(params["t3"])),
      "max_be" => character.be,
      "character_id" => character.id,
      "group_id" => character.group_id
    })

    case Event.create_talent_roll(params) do
      {:ok, _roll} ->
        {:noreply, socket
        |> assign(:changeset_roll, nil)
        |> assign(:group, Accounts.get_group!(socket.assigns.group.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset_roll, changeset)}
    end
  end

  def handle_event("event", %{"trait_roll" => %{"trait" => trait} = params}, socket) do

    character = active_character(socket)

    params = Map.merge(params, %{
      "w1" => Enum.random(1..20),
      "w1b" => Enum.random(1..20),
      "level" => Map.get(character, String.to_atom(trait)),
      "max_be" => character.be,
      "character_id" => character.id,
      "group_id" => character.group_id
    })

    case Event.create_trait_roll(params) do
      {:ok, _roll} ->
        {:noreply, socket
        |> assign(:changeset_roll, nil)
        |> assign(:group, Accounts.get_group!(socket.assigns.group.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset_roll, changeset)}
    end
  end

  def handle_event("delete", %{"trait_roll" => id}, socket) do
    socket.assigns.group.trait_rolls
    |> Enum.find(& &1.id == String.to_integer(id))
    |> Event.delete_roll!()

    {:noreply, assign(socket, :group, Accounts.get_group!(socket.assigns.group.id))}
  end

  defp active_character(socket) do
    id = socket.assigns.changeset_active_character.changes.id
    Enum.find(socket.assigns.group.characters, & &1.id == id)
  end
end
