defmodule DsaWeb.GroupLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  import DsaWeb.Gettext
  import DsaWeb.GroupView

  alias Dsa.{Characters, Logs, Trial}
  alias Dsa.Logs.Event.Type
  alias DsaWeb.LogLive

  require Logger

  def render(assigns), do: Phoenix.View.render(DsaWeb.GroupView, "live.html", assigns)

  def mount(_params, %{"group_id" => group_id, "user_id" => user_id}, socket) do
    characters = Characters.get_group_characters!(group_id)

    DsaWeb.Endpoint.subscribe(topic(group_id))

    {:ok, socket
    |> assign(:characters, characters)
    |> assign(:group_id, group_id)
    |> assign(:user_id, user_id)}
  end

  # not yet logged in (first mount call)
  def mount(params, %{"group_id" => group_id}, socket) do
    mount(params, %{"group_id" => group_id, "user_id" => nil}, socket)
  end

  defp topic(id), do: "group:#{id}"

  defp broadcast(socket, message) do
    Phoenix.PubSub.broadcast!(Dsa.PubSub, topic(socket.assigns.group_id), message)
  end

  def handle_event("change", %{"character" =>  %{"id" => id, "active_combat_set_id" => set_id}}, socket) do

    character = Enum.find(socket.assigns.characters, & &1.id == String.to_integer(id))
    params = %{active_combat_set_id: set_id}

    case Characters.update(character, params) do
      {:ok, _character} -> broadcast(socket, :update_characters)
      {:error, changeset} -> Logger.error inspect changeset
    end
    {:noreply, socket}
  end

  def handle_event("roll-at", %{"id" => id}, socket) do
    character = Enum.find(socket.assigns.characters, & &1.id == String.to_integer(id))

    at = character.active_combat_set.at
    dice = Trial.roll()
    [first, second] = Trial.roll(2, 20, dice)

    critical? = (first == 1 && second <= at) || (first == 20 && second > at)
    success? = first <= at
    {result, result_type} = Logs.trial_result_type(success?, critical?)

    params = %{
      type: Type.ATRoll,
      group_id: socket.assigns.group_id,
      character_id: character.id,
      character_name: character.name,
      roll: dice,
      left: character.active_combat_set.name,
      right: result,
      result_type: result_type,
    }

    case Logs.create_event(params) do
      {:ok, event} -> LogLive.broadcast(socket.assigns.group_id, {:log, event})
      {:error, changeset} -> Logger.error inspect changeset
    end

    {:noreply, socket}
  end

  def handle_event("roll-pa", %{"id" => id}, socket) do
    character = Enum.find(socket.assigns.characters, & &1.id == String.to_integer(id))

    pa = character.active_combat_set.pa
    dice = Trial.roll()
    [first, second] = Trial.roll(2, 20, dice)

    critical? = (first == 1 && second <= pa) || (first == 20 && second > pa)
    success? = first <= pa
    {result, result_type} = Logs.trial_result_type(success?, critical?)

    params = %{
      type: Type.PARoll,
      group_id: socket.assigns.group_id,
      character_id: character.id,
      character_name: character.name,
      roll: dice,
      right: result,
      result_type: result_type,
    }

    case Logs.create_event(params) do
      {:ok, event} -> LogLive.broadcast(socket.assigns.group_id, {:log, event})
      {:error, changeset} -> Logger.error inspect changeset
    end

    {:noreply, socket}
  end

  def handle_event("roll-ini", %{"id" => id}, socket) do
    character = Enum.find(socket.assigns.characters, & &1.id == String.to_integer(id))

    ini = if is_nil(character.ini), do: character.ini_basis + Enum.random(1..6), else: nil

    case Characters.update(character, %{ini: ini}) do
      {:ok, character} ->
        log_params = %{
          type: Type.INIRoll,
          group_id: socket.assigns.group_id,
          character_id: character.id,
          character_name: character.name,
          roll: ini
        }

        case Logs.create_event(log_params) do
          {:ok, entry} ->
            broadcast(socket, :update_characters)
            LogLive.broadcast(socket.assigns.group_id, {:log, entry})

          {:error, changeset} ->
            Logger.error inspect changeset
        end

      {:error, changeset} ->
        Logger.error inspect changeset
    end
    {:noreply, socket}
  end

  def handle_event("roll-dmg", %{"id" => id}, socket) do
    character = Enum.find(socket.assigns.characters, & &1.id == String.to_integer(id))

    %{tp_dice: count, tp_type: type, tp_bonus: bonus} = character.active_combat_set

    roll = Trial.roll()
    dice = Trial.roll(count, type, roll)

    params = %{
      type: Type.DMGRoll,
      group_id: socket.assigns.group_id,
      character_id: character.id,
      character_name: character.name,
      roll: roll,
      left: dmg(character.active_combat_set),
      right: Integer.to_string(Enum.sum(dice) + bonus)
    }

    case Logs.create_event(params) do
      {:ok, event} -> LogLive.broadcast(socket.assigns.group_id, {:log, event})
      {:error, changeset} -> Logger.error inspect changeset
    end

    {:noreply, socket}
  end

  def handle_info(:update_characters, socket) do
    characters = Characters.get_group_characters!(socket.assigns.group_id)
    {:noreply, assign(socket, :characters, characters)}
  end
end
