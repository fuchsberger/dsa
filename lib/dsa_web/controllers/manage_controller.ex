defmodule DsaWeb.ManageController do
  use DsaWeb, :controller

  import Algolia

  def sync_search(conn, _params) do

    sync_pages(conn)

    conn
    |> put_flash(:info, gettext("Search has been syncronized."))
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp sync_pages(conn) do
    # entries = read_file("#{@data_path}/pages.json")

    entries = [%{
      objectID: Routes.user_session_path(conn, :new),
      type: :page,
      title: "Login",
      desc: "Sign into your account.",
      path: Routes.user_session_path(conn, :new)
    }]

    save_objects("records", entries)
  end
end
