defmodule DsaWeb.DsaLive do
  use Phoenix.LiveView, layout: {DsaWeb.LayoutView, "live.html"}

  def render(assigns), do: Phoenix.View.render(DsaWeb.DsaView, "index.html", assigns)

  def mount(_params, session, socket) do

    {:ok, socket
    |> assign(:page_title, "Home")
    |> assign(:account_dropdown_open?, false)
    |> assign(:menu_open?, false)}
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
