defmodule DsaWeb.PageController do
  use DsaWeb, :controller

  def index(conn, _) do
    render(conn, "index.html")
  end
end
