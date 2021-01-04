defmodule DsaWeb.DsaLive do
  use Phoenix.LiveView, layout: {DsaWeb.LayoutView, "live.html"}

  import Phoenix.View, only: [render: 3]

  alias Dsa.{Accounts, Event, Repo, UI}
  alias DsaWeb.PageView
  alias DsaWeb.Router.Helpers, as: Routes

  require Logger

  @group_id 1 # TODO: Group 1 is hardcoded. Make dynamic.

  defp topic(group_id), do: "group:#{group_id}"

  def render(assigns) do
    ~L"""
    <%= case @live_action do %>
      <% :login -> %>
        <%= live_component @socket, DsaWeb.LoginComponent, id: :login, error: @invalid_login? %>

      <% :dashboard -> %><%= render PageView, "dashboard.html", assigns %>
      <% :character -> %><%= render PageView, "character.html", assigns %>
      <% :roll -> %><%= render PageView, "roll.html", assigns %>
    <% end %>
    """
  end

  def mount(params, session, socket) do

    user =
      case Map.get(session, "user_id") do
        nil ->
          nil

        user_id ->
          user = Accounts.get_user!(user_id)

          gravatar = "https://s.gravatar.com/avatar/"
            <> Base.encode16(:erlang.md5("alex.fuchsberger@gmail.com"), case: :lower)
            <> "?s=24"

          Map.put(user, :gravatar, gravatar)
      end

    DsaWeb.Endpoint.subscribe(topic(@group_id))

    logs = Event.list_logs(@group_id) # TODO: hard-coded for now
    logsetting_changeset = UI.change_logsetting()

    {:ok, socket

    # dashboard
    |> assign(:characters, (if is_nil(user), do: [], else: user.characters))

    # log related
    |> assign(:log_changeset, logsetting_changeset)
    |> assign(:log_empty?, Enum.count(logs) == 0)
    |> assign(:log_resetcount, 0)
    |> assign(:logs, logs)
    |> assign(:dice, Ecto.Changeset.get_field(logsetting_changeset, :dice))
    |> assign(:result, Ecto.Changeset.get_field(logsetting_changeset, :result))

    # roll related
    |> assign(:roll_changeset, UI.change_roll())

    # other
    |> assign(:user, user)
    |> assign(:event_changeset, Event.change_log())
    |> assign(:show_log?, false)
    |> assign(:character_id, 1) # TODO: set to active character
    |> assign(:group_id, @group_id) # TODO: hard-coded for now
    |> assign(:invalid_login?, Map.has_key?(params, "invalid_login")),
    temporary_assigns: [logs: []]}
  end

  def handle_info(%{event: "clear-logs"}, socket) do
    {:noreply, socket
    |> assign(:log_empty?, true)
    |> assign(:logs, [false]) # forces temporary assign to be treated as updated
    |> assign(:logs, [])
    |> assign(:log_resetcount, socket.assigns.log_resetcount + 1)}
  end

  def handle_info(%{event: "log", payload: log}, socket) do
    {:noreply, socket
    |> assign(:log_empty?, false)
    |> assign(:logs, [log])}
  end

  def handle_params(params, _uri, socket) do

    user = socket.assigns.user

    cond do
      # if user is not authenticated and action is not login page, redirect to login page
      socket.assigns.live_action != :login && is_nil(user) ->
        {:noreply, push_patch(socket, to: Routes.dsa_path(socket, :login), replace: true)}

      # if no active character and page is not dashboard redirect to dashboard
      not is_nil(user) && socket.assigns.live_action != :dashboard && is_nil(user.active_character_id) ->
        {:noreply, push_patch(socket, to: Routes.dsa_path(socket, :dashboard), replace: true)}

      # all went well, proceed
      true ->

        # reset some general assigns
        socket =
          socket
          |> assign(:character_changeset, nil)
          |> assign(:log_open?, false)
          |> assign(:account_dropdown_open?, false)
          |> assign(:menu_open?, false)

        # handle page title
        socket =
          case socket.assigns.live_action do
            :login ->
              assign(socket, :page_title, "Login")

            :character ->
              socket
              |> assign(:page_title, "Held")
              |> assign(:character_changeset, Accounts.change_character(socket.assigns.user.active_character))

            :dashboard ->
              assign(socket, :page_title, "Übersicht")

            :roll ->
              assign(socket, :page_title, "Probe")

            _ ->
              socket
          end

        {:noreply, socket
        |> assign(:log_open?, false)
        |> assign(:account_dropdown_open?, false)
        |> assign(:menu_open?, false)}
    end
  end

  def handle_event("activate", %{"character" => id}, socket) do
    id = String.to_integer(id)
    id = if id == socket.assigns.user.active_character_id, do: nil, else: id

    case Accounts.update_user(socket.assigns.user, %{active_character_id: id}) do
      {:ok, character} ->
        {:noreply, assign(socket, :user, Accounts.get_user!(socket.assigns.user.id))}

      {:error, changeset} ->
        Logger.error("An error occured when toggling active character: \n#{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"roll" => params}, socket) do
    {:noreply, socket
    |> assign(:roll_changeset, UI.change_roll(params))}
  end

  def handle_event("change", %{"character" => params}, socket) do
    changeset = Accounts.change_character(socket.assigns.user.active_character, params)

    {:noreply, socket
    |> assign(:character_changeset, changeset)}
  end

  def handle_event("change", %{"log_setting" => params}, socket) do
    changeset = UI.change_logsetting(params)

    {:noreply, socket
    |> assign(:dice, Ecto.Changeset.get_field(changeset, :dice))
    |> assign(:result, Ecto.Changeset.get_field(changeset, :result))
    |> assign(:log_changeset, changeset)
    |> assign(:logs, Event.list_logs(@group_id)) # TODO: hard-coded for now
    |> assign(:log_resetcount, socket.assigns.log_resetcount + 1)}
  end

  def handle_event("clear-log", _params, socket) do
    case Event.delete_logs(socket.assigns.group_id) do
      {0, _} ->
        Logger.warn("No log entries exist for deleting.")
        {:noreply, socket}

      {count, _} ->
        Logger.warn("#{count} log entries deleted.")
        DsaWeb.Endpoint.broadcast(topic(socket.assigns.group_id), "clear-logs", %{})
        {:noreply, socket}
    end
  end

  def handle_event("close-account-dropdown", %{"key" => "Esc"}, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, false)}
  end

  def handle_event("close-account-dropdown", %{"key" => "Escape"}, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, false)}
  end

  def handle_event("close-account-dropdown", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("quickroll", %{"type" => type}, socket) do

    params =
      case type do
        "w20" ->
          %{
            type: 1,
            x1: Enum.random(1..20),
            character_id: socket.assigns.user.active_character_id,
            group_id: socket.assigns.group_id
          }

        "w6" ->
          %{
            type: 2,
            x1: Enum.random(1..6),
            character_id: socket.assigns.user.active_character_id,
            group_id: socket.assigns.group_id
          }

        "2w6" ->
          %{
            type: 3,
            x1: Enum.random(1..6),
            x2: Enum.random(1..6),
            character_id: socket.assigns.user.active_character_id,
            group_id: socket.assigns.group_id
          }

        "3w6" ->
          %{
            type: 4,
            x1: Enum.random(1..6),
            x2: Enum.random(1..6),
            x3: Enum.random(1..6),
            character_id: socket.assigns.user.active_character_id,
            group_id: socket.assigns.group_id
          }

        "3w20" ->
          %{
            type: 5,
            x1: Enum.random(1..20),
            x2: Enum.random(1..20),
            x3: Enum.random(1..20),
            character_id: socket.assigns.user.active_character_id,
            group_id: socket.assigns.group_id
          }
      end

    case Event.create_log(params) do
      {:ok, log} ->
        DsaWeb.Endpoint.broadcast(topic(log.group_id), "log", Repo.preload(log, :character))
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("roll", %{"trait" => trait}, socket) do

    trait = String.to_atom(trait)

    params =
      %{
        type: 6,
        x1: Enum.find_index(~w(mu kl in ch ge ff ko kk)a, & &1 == trait), # trait
        x2: Map.get(socket.assigns.user.active_character, trait), # trait value
        x3: Ecto.Changeset.get_field(socket.assigns.roll_changeset, :modifier), # modifier
        x4: Enum.random(1..20), # result
        x5: Enum.random(1..20), # result confirmation
        character_id: socket.assigns.user.active_character_id,
        group_id: socket.assigns.group_id
      }

    case Event.create_log(params) do
      {:ok, log} ->
        DsaWeb.Endpoint.broadcast(topic(log.group_id), "log", Repo.preload(log, :character))
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("talent-roll", _params, socket) do

    trait_1 = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :e1)
    trait_2 = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :e2)
    trait_3 = Ecto.Changeset.get_field(socket.assigns.roll_changeset, :e3)

    trait_value_1 = Enum.at(~w(mu kl in ch ge ff ko kk)a, trait_1)
    trait_value_2 = Enum.at(~w(mu kl in ch ge ff ko kk)a, trait_2)
    trait_value_3 = Enum.at(~w(mu kl in ch ge ff ko kk)a, trait_3)

    params =
      %{
        type: 7,
        x1: trait_1,
        x2: trait_2,
        x3: trait_3,
        x4: Map.get(socket.assigns.user.active_character, trait_value_1),
        x5: Map.get(socket.assigns.user.active_character, trait_value_2),
        x6: Map.get(socket.assigns.user.active_character, trait_value_3),
        x7: Enum.random(1..20),
        x8: Enum.random(1..20),
        x9: Enum.random(1..20),
        x10: Ecto.Changeset.get_field(socket.assigns.roll_changeset, :modifier),
        x11: Ecto.Changeset.get_field(socket.assigns.roll_changeset, :tw),
        character_id: socket.assigns.user.active_character_id,
        group_id: socket.assigns.group_id
      }

    case Event.create_log(params) do
      {:ok, log} ->
        DsaWeb.Endpoint.broadcast(topic(log.group_id), "log", Repo.preload(log, :character))
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def handle_event("toggle-account-dropdown", _params, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, !socket.assigns.account_dropdown_open?)}
  end

  def handle_event("toggle-log", _params, socket) do
    {:noreply, assign(socket, :log_open?, !socket.assigns.log_open?)}
  end

  def handle_event("toggle-menu", _params, socket) do
    {:noreply, assign(socket, :menu_open?, !socket.assigns.menu_open?)}
  end

  def handle_event("update", %{"character" => params}, socket) do
    case Accounts.update_character(socket.assigns.user.active_character, params) do
      {:ok, character} ->
        user = Accounts.get_user!(socket.assigns.user.id)

        {:noreply, socket
        |> assign(:user, user)
        |> assign(:characters, user.characters)
        |> assign(:character_changeset, Accounts.change_character(character))}

      {:error, changeset} ->
        Logger.error("Error occured while updating character: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end
end
