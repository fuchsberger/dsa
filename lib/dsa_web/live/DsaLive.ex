defmodule DsaWeb.DsaLive do
  use Phoenix.LiveView, layout: {DsaWeb.LayoutView, "live.html"}

  alias Dsa.{Accounts, Event, UI}
  alias DsaWeb.Router.Helpers, as: Routes

  require Logger

  @group_id 1 # TODO: Group 1 is hardcoded. Make dynamic.

  def topic, do: "group:#{@group_id}"

  def render(assigns) do
    ~L"""
    <%= case @live_action do %>
      <% :login -> %>
        <%= live_component @socket, DsaWeb.LoginComponent, id: :login, error: @invalid_login? %>

      <% :dashboard -> %>
        <%= live_component @socket, DsaWeb.DashboardComponent, id: :dashboard,
          character_id: @character_id,
          user_id: @user_id
        %>

      <% :character -> %>
        <%= live_component @socket, DsaWeb.CharacterComponent, id: :character, character_id: @character_id %>

      <% :roll -> %>
        <%= live_component @socket, DsaWeb.RollComponent, id: :roll, character_id: @character_id %>
    <% end %>
    """
  end

  def mount(params, session, socket) do

    {user_id, username, email, active_character_id} =
      session
      |> Map.get("user_id")
      |> Accounts.get_user_base_data!()

    DsaWeb.Endpoint.subscribe(topic())

    logs = Event.list_logs(@group_id) # TODO: hard-coded for now
    logsetting_changeset = UI.change_logsetting()

    {:ok, socket
    # log related
    |> assign(:log_changeset, logsetting_changeset)
    |> assign(:log_empty?, Enum.count(logs) == 0)
    |> assign(:log_resetcount, 0)
    |> assign(:logs, logs)
    |> assign(:dice, Ecto.Changeset.get_field(logsetting_changeset, :dice))
    |> assign(:result, Ecto.Changeset.get_field(logsetting_changeset, :result))

    # userdata
    |> assign(:username, username)
    |> assign(:email, email)
    |> assign(:character_id, active_character_id)
    |> assign(:user_id, user_id)
    |> assign(:gravatar_url, gravatar_url(email))

    |> assign(:event_changeset, Event.change_log())
    |> assign(:show_log?, false)
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

  def handle_info({:update, %{character_id: id}}, socket) do
    {:noreply, assign(socket, :character_id, id)}
  end

  def handle_params(_params, _uri, socket) do
    authenticated? = not is_nil(socket.assigns.user_id)

    cond do
      # if user is not authenticated and action is not login page, redirect to login page
      socket.assigns.live_action != :login && not authenticated? ->
        {:noreply, push_patch(socket, to: Routes.dsa_path(socket, :login), replace: true)}

      # if no active character and page is not dashboard redirect to dashboard
      authenticated? && socket.assigns.live_action != :dashboard && is_nil(socket.assigns.character_id) ->
        {:noreply, push_patch(socket, to: Routes.dsa_path(socket, :dashboard), replace: true)}

      # all went well, proceed
      true ->

        # reset some general assigns
        socket =
          socket
          |> assign(:log_open?, false)
          |> assign(:account_dropdown_open?, false)
          |> assign(:menu_open?, false)

        # handle page title
        socket =
          case socket.assigns.live_action do
            :login -> assign(socket, :page_title, "Login")
            :character -> assign(socket, :page_title, "Held")
            :dashboard -> assign(socket, :page_title, "Übersicht")
            :roll -> assign(socket, :page_title, "Probe")

            _ ->
              socket
          end

        {:noreply, socket
        |> assign(:log_open?, false)
        |> assign(:account_dropdown_open?, false)
        |> assign(:menu_open?, false)}
    end
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
        DsaWeb.Endpoint.broadcast(topic(), "clear-logs", %{})
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

  def handle_event("toggle-account-dropdown", _params, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, !socket.assigns.account_dropdown_open?)}
  end

  def handle_event("toggle-log", _params, socket) do
    {:noreply, assign(socket, :log_open?, !socket.assigns.log_open?)}
  end

  def handle_event("toggle-menu", _params, socket) do
    {:noreply, assign(socket, :menu_open?, !socket.assigns.menu_open?)}
  end

  defp gravatar_url(email, size \\ 24)

  defp gravatar_url(nil, size), do: "https://s.gravatar.com/avatar/invalid?s=#{size}"

  defp gravatar_url(email, size) do
    "https://s.gravatar.com/avatar/#{Base.encode16(:erlang.md5(email), case: :lower)}?s=#{size}"
  end
end
