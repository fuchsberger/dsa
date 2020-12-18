defmodule DsaWeb.DsaLive do
  use Phoenix.LiveView, layout: {DsaWeb.LayoutView, "live.html"}

  alias Dsa.Accounts

  def render(assigns), do: Phoenix.View.render(DsaWeb.DsaView, "index.html", assigns)

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
    |> assign(:page_title, "Home")
    |> assign(:account_dropdown_open?, false)
    |> assign(:menu_open?, false)
    |> assign(:user, user)}
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
