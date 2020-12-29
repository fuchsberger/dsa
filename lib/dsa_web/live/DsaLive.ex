defmodule DsaWeb.DsaLive do
  use Phoenix.LiveView, layout: {DsaWeb.LayoutView, "live.html"}

  import Phoenix.View, only: [render: 3]

  alias Dsa.Accounts
  alias DsaWeb.PageView
  alias DsaWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <%= render PageView, "login.html", assigns %>
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

    {:ok, socket
    |> assign(:user, user)
    |> assign(:show_log?, false)
    |> assign(:invalid_login?, Map.has_key?(params, "invalid_login"))}
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
