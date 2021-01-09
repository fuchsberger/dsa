defmodule DsaWeb.DsaLive do
  use Phoenix.LiveView, layout: {DsaWeb.LayoutView, "live.html"}

  alias Dsa.Accounts
  alias DsaWeb.Router.Helpers, as: Routes

  require Logger

  @group_id 1

  def topic, do: "log:#{@group_id}"

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

    {:ok, socket
    |> assign(:username, username)
    |> assign(:email, email)
    |> assign(:character_id, active_character_id)
    |> assign(:user_id, user_id)
    |> assign(:gravatar_url, gravatar_url(email))
    |> assign(:show_log?, false)
    |> assign(:invalid_login?, Map.has_key?(params, "invalid_login"))}
  end

  def handle_info({:log, entry}, socket) do
    send_update(DsaWeb.LogComponent, id: :log, action: :add, entry: entry)
    {:noreply, assign(socket, :log_open?, true)}
  end

  def handle_info(:clear_logs, socket) do
    send_update(DsaWeb.LogComponent, id: :log, action: :clear)
    {:noreply, socket}
  end

  def handle_info({:update, %{character_id: id}}, socket) do
    {:noreply, assign(socket, :character_id, id)}
  end

  def handle_info(unknown, socket) do
    Logger.warn(inspect(unknown))
    {:noreply, socket}
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
        # handle page title
        socket =
          case socket.assigns.live_action do
            :login -> assign(socket, :page_title, "Login")
            :character -> assign(socket, :page_title, "Held")
            :dashboard -> assign(socket, :page_title, "Übersicht")
            :roll -> assign(socket, :page_title, "Probe")
            _ -> assign(socket, :page_title, "404 Error")
          end

        {:noreply, socket
        |> assign(:log_open?, false)
        |> assign(:account_dropdown_open?, false)
        |> assign(:menu_open?, false)}
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
