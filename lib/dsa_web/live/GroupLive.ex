defmodule DsaWeb.GroupLive do

  use Phoenix.LiveView
  alias Dsa.Game

  def render(assigns), do: DsaWeb.GameView.render("group.html", assigns)

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
