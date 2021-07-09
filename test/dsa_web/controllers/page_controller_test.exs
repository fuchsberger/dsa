defmodule DsaWeb.PageControllerTest do
  use DsaWeb.ConnCase, async: true

  describe "GET /" do
    test "renders welcome page", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ gettext("Willkommen in Aventurien!")
    end
  end
end
