defmodule DsaWeb.PageController do
  use DsaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
