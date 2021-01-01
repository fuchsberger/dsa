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
      <%= render PageView, "login.html", assigns %>
      <%= render PageView, "dashboard.html", assigns %>
      <%= render PageView, "roll.html", assigns %>
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

    logsetting_changeset = UI.change_logsetting()


    {:ok, socket
    |> assign(:dice, Ecto.Changeset.get_field(logsetting_changeset, :dice))
    |> assign(:result, Ecto.Changeset.get_field(logsetting_changeset, :result))
    |> assign(:user, user)
    |> assign(:log_action, "prepend")
    |> assign(:log_changeset, logsetting_changeset)
    |> assign(:event_changeset, Event.change_log())
    |> assign(:logs, Event.list_logs(@group_id)) # TODO: hard-coded for now
    |> assign(:show_log?, false)
    |> assign(:character_id, 1) # TODO: set to active character
    |> assign(:group_id, @group_id) # TODO: hard-coded for now
    |> assign(:invalid_login?, Map.has_key?(params, "invalid_login")),
    temporary_assigns: [logs: []]}
  end

  def handle_info(%{event: "clear-logs"}, socket) do
    Logger.warn("CLEAR EVENT")
    {:noreply, socket
    |> assign(:log_action, "replace")
    |> assign(:logs, [])}
  end

  def handle_info(%{event: "log", payload: log}, socket) do
    {:noreply, socket
    |> assign(:log_action, "prepend")
    |> assign(:logs, [log])}
  end

  def handle_params(params, _uri, socket) do
    # if user is not authenticated and action is not login page, redirect to login page
    if socket.assigns.live_action != :login && is_nil(socket.assigns.user) do
      {:noreply, push_patch(socket, to: Routes.dsa_path(socket, :login), replace: true)}
    else
      # handle page title
      socket =
        case socket.assigns.live_action do
          :login ->
            assign(socket, :page_title, "Login")
          _ ->
            assign(socket, :page_title, "Home")
        end

      {:noreply, socket
      |> assign(:session_changeset, Accounts.change_session())
      |> assign(:log_open?, false)
      |> assign(:account_dropdown_open?, false)
      |> assign(:menu_open?, false)
      |> assign(:trigger_submit_login?, false)}
    end
  end

  def handle_event("change", %{"session" => params}, socket) do
    {:noreply, socket
    |> assign(:session_changeset, Accounts.change_session(params))
    |> assign(:invalid_login?, false)}
  end

  def handle_event("change", %{"log_setting" => params}, socket) do
    changeset = UI.change_logsetting(params)

    Logger.warn "Logs reloaded"

    {:noreply, socket
    |> assign(:dice, Ecto.Changeset.get_field(changeset, :dice))
    |> assign(:result, Ecto.Changeset.get_field(changeset, :result))
    |> assign(:log_changeset, changeset)
    |> assign(:logs, Event.list_logs(@group_id))} # TODO: hard-coded for now
  end

  def handle_event("clear-log", _params, socket) do
    case Event.delete_logs(socket.assigns.group_id) do
      {0, _} ->
        Logger.warn("No log entries exist for deleting.")
        {:noreply, socket}

      {count, _} ->
        Logger.warn("#{count} log entries deleted")
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

  def handle_event("login", %{"session" => %{"email" => email, "password" => pass}}, socket) do
    {:noreply, assign(socket, :trigger_submit_login?, true)}
  end

  def handle_event("quickroll", %{"type" => type}, socket) do

    params =
      case type do
        "w20" ->
          %{
            type: 1,
            x1: Enum.random(1..20),
            character_id: socket.assigns.character_id,
            group_id: socket.assigns.group_id
          }

        "w6" ->
          %{
            type: 2,
            x1: Enum.random(1..6),
            character_id: socket.assigns.character_id,
            group_id: socket.assigns.group_id
          }

        "2w6" ->
          %{
            type: 3,
            x1: Enum.random(1..6),
            x2: Enum.random(1..6),
            character_id: socket.assigns.character_id,
            group_id: socket.assigns.group_id
          }

        "3w6" ->
          %{
            type: 4,
            x1: Enum.random(1..6),
            x2: Enum.random(1..6),
            x3: Enum.random(1..6),
            character_id: socket.assigns.character_id,
            group_id: socket.assigns.group_id
          }

        "3w20" ->
          %{
            type: 5,
            x1: Enum.random(1..20),
            x2: Enum.random(1..20),
            x3: Enum.random(1..20),
            character_id: socket.assigns.character_id,
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

  def handle_event("toggle-account-dropdown", _params, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, !socket.assigns.account_dropdown_open?)}
  end

  def handle_event("toggle-log", _params, socket) do
    {:noreply, assign(socket, :log_open?, !socket.assigns.log_open?)}
  end

  def handle_event("toggle-menu", _params, socket) do
    {:noreply, assign(socket, :menu_open?, !socket.assigns.menu_open?)}
  end
end
