defmodule DsaWeb.DsaLive do
  use Phoenix.LiveView, layout: {DsaWeb.LayoutView, "live.html"}

  alias Dsa.Accounts
  alias DsaWeb.Router.Helpers, as: Routes

  require Logger

  @group_id 1

  def broadcast(message), do: Phoenix.PubSub.broadcast!(Dsa.PubSub, topic(), message)

  def topic, do: "log:#{@group_id}"

  def render(assigns) do
    ~L"""
    <%= case @live_action do %>
      <% :combat -> %>
        <%= live_component @socket, DsaWeb.CombatComponent,
          id: :combat,
          user: @user,
          visible_characters: @visible_characters
        %>

      <% :roll -> %>
        <%= live_component @socket, DsaWeb.ModifierComponent, modifier: @modifier %>
        <%= live_component @socket, DsaWeb.RollComponent,
          id: :roll,
          character: @user.active_character,
          modifier: @modifier
        %>

      <% _ -> %>
        <%= live_component @socket, DsaWeb.ErrorComponent, type: 404 %>
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
    |> assign(:email, Map.get(params, "email"))
    |> assign(:group_options, Accounts.list_group_options())
    |> assign(:modifier, 0)
    |> assign(:show_log?, false)
    |> assign(:reset_user, nil)
    |> assign(:token, Map.get(params, "token"))
    |> assign(:user, user)
    |> assign(:visible_characters, Accounts.get_visible_characters())}
  end

  def handle_info(:update_user, socket) do
    {:noreply, socket
    |> assign(:user, Accounts.get_user!(socket.assigns.user.id))
    |> assign(:visible_characters, Accounts.get_visible_characters())}
  end

  def handle_info({:log, entry}, socket) do
    send_update(DsaWeb.LogComponent, id: :log, action: :add, entry: entry)
    {:noreply, assign(socket, :log_open?, true)}
  end

  def handle_info(:clear_logs, socket) do
    send_update(DsaWeb.LogComponent, id: :log, action: :clear)
    {:noreply, socket}
  end

  def handle_info({:update_character, character}, socket) do
    {:noreply, assign(socket, :user, Map.put(socket.assigns.user, :active_character, character))}
  end

  def handle_params(_params, _uri, socket) do

    %{live_action: action, user: user} = socket.assigns

    cond do
      # Do not allow unauthenticated users to access restricted pages
      is_nil(user) && Enum.member?([:combat, :skills, :roll], action) ->
        {:noreply, socket
        |> put_flash(:error, "Die angeforderte Seite benötigt Authentifizierung.")
        |> redirect(to: Routes.session_path(socket, :new))}

      # redirect to dashboard if user does not has an active character and page requires it
      not is_nil(user) && is_nil(user.active_character_id) && Enum.member?([:roll, :skills], action) ->
        {:noreply, push_patch(socket, to: Routes.user_path(socket, :edit, user), replace: true)}

      # all went normal, proceed
      true ->
        {:noreply, socket
        |> assign(:log_open?, false)
        |> assign(:account_dropdown_open?, false)
        |> assign(:menu_open?, false)}
    end
  end

  def handle_event("assign", %{"modifier" => modifier}, socket) do
    {:noreply, assign(socket, :modifier, String.to_integer(modifier))}
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

  def handle_event("update_character", params, socket) do
    Accounts.update_character!(socket.assigns.user.active_character, params)
    broadcast(:update_user)
    {:noreply, socket}
  end
end
