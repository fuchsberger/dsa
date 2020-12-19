defmodule DsaWeb.DsaLive do
  use Phoenix.LiveView, layout: {DsaWeb.LayoutView, "live.html"}

  import Phoenix.View, only: [render: 3]

  alias Dsa.Accounts
  alias DsaWeb.PageView

  def render(assigns) do
    ~L"""
    <%= render PageView, "login.html", assigns %>
    """
  end

  def mount(_params, session, socket) do

    user =
      case Map.get(session, :user_id) do
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
    |> assign(:user, user)}
  end

  def handle_params(_params, _uri, socket) do
    # handle page title
    socket =
      case socket.assigns.live_action do
        :login -> assign(socket, :page_title, "Login")
        _ -> assign socket, :page_title, "Home"
      end

    {:noreply, socket
    |> assign(:account_dropdown_open?, false)
    |> assign(:menu_open?, false)
    |> assign(:login_changeset, Accounts.change_login())
    |> assign(:trigger_submit_login?, false)}
  end

  def handle_event("close-account-dropdown", %{"key" => "Esc"}, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, false)}
  end

  def handle_event("close-account-dropdown", %{"key" => "Escape"}, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, false)}
  end

  def handle_event("toggle-account-dropdown", _params, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, !socket.assigns.account_dropdown_open?)}
  end

  def handle_event("toggle-menu", _params, socket) do
    {:noreply, assign(socket, :menu_open?, !socket.assigns.menu_open?)}
  end
end
