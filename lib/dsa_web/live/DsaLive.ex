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
      <% :change_password -> %>
        <%= live_component @socket, DsaWeb.ChangePasswordComponent, id: :change_password, user: @user %>

      <% :login -> %>
        <%= live_component @socket, DsaWeb.LoginComponent, id: :login %>

      <% :dashboard -> %>
        <%= live_component @socket, DsaWeb.DashboardComponent, id: :dashboard, user: @user %>

      <% :character -> %>
        <%= live_component @socket, DsaWeb.CharacterComponent, id: :character, character_id: @character_id %>

      <% :roll -> %>
        <%= live_component @socket, DsaWeb.RollComponent, id: :roll, character_id: @character_id %>

      <% :reset_password -> %>
        <%= live_component @socket, DsaWeb.ResetPasswordComponent, id: :reset_password %>

      <% :error404 -> %>
        <%= live_component @socket, DsaWeb.ErrorComponent, type: 404 %>

      <% _ -> %>
        <%= live_component @socket, DsaWeb.AccountComponent, id: :account, action: @live_action %>
    <% end %>
    """
  end

  def mount(params, session, socket) do

    user_id = Map.get(session, "user_id")
    user = user_id && Accounts.get_user!(user_id)

    # Add error message from param if it exists
    error = Map.get(params, "error")
    socket = if is_nil(error), do: socket, else: put_flash(socket, :error, error)

    DsaWeb.Endpoint.subscribe(topic())

    {:ok, socket
    |> assign(:show_log?, false)
    |> assign(:user, user)}
  end

  def handle_info({:log, entry}, socket) do
    send_update(DsaWeb.LogComponent, id: :log, action: :add, entry: entry)
    {:noreply, assign(socket, :log_open?, true)}
  end

  def handle_info(:clear_logs, socket) do
    send_update(DsaWeb.LogComponent, id: :log, action: :clear)
    {:noreply, socket}
  end

  def handle_info({:update_user, user}, socket), do: {:noreply, assign(socket, :user, user)}

  def handle_info(unknown, socket) do
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do

    %{live_action: action, user: user} = socket.assigns

    cond do
      # if user is not authenticated and action is not a public page redirect to login page
      is_nil(user) && not Enum.member?([:login, :error404, :register, :reset_password], action) ->
        {:noreply, push_patch(socket, to: Routes.dsa_path(socket, :login), replace: true)}

      not is_nil(user) && action == :index ->
        {:noreply, push_patch(socket, to: Routes.dsa_path(socket, :dashboard), replace: true)}

      # if no active character and page requires one redirect to dashboard
      not is_nil(user) && is_nil(user.active_character_id) && Enum.member?([:roll, :character], action) ->
        {:noreply, push_patch(socket, to: Routes.dsa_path(socket, :dashboard), replace: true)}

      # all went well, proceed
      true ->
        # handle page title
        socket =
          case socket.assigns.live_action do
            :change_password -> assign(socket, :page_title, "Account")

            :login -> assign(socket, :page_title, "Login")
            :character -> assign(socket, :page_title, "Held")
            :dashboard -> assign(socket, :page_title, "Übersicht")
            :register -> assign(socket, :page_title, "Registrierung")
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

  defp gravatar_url(user, size \\ 24)

  defp gravatar_url(nil, size), do: "https://s.gravatar.com/avatar/invalid?s=#{size}"

  defp gravatar_url(user, size) do
    "https://s.gravatar.com/avatar/#{Base.encode16(:erlang.md5(user.email), case: :lower)}?s=#{size}"
  end
end
