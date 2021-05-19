defmodule DsaWeb.UserRegistrationControllerTest do
  use DsaWeb.ConnCase, async: true

  import Dsa.AccountsFixtures
  import DsaWeb.AccountTranslations

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ t(:heading_registration) <> "</h2>"
      assert response =~ t(:signin_link) <> "</a>"
      assert response =~ t(:sign_up) <> "</button>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and DOES NOT log the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => email,
            "password" => valid_user_password(),
            "password_confirmation" => valid_user_password(),
            "username" => valid_user_username()
          }
        })

      refute get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/login"
      assert flash_messages_contain(conn, t(:registration_successful))
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => "with spaces",
            "password" => "too short",
            "password_confirmation" => "does not match",
            "username" => ""
          }
        })

      response = html_response(conn, 200)
      assert response =~ t(:heading_registration) <> "</h2>"
      assert response =~ dgettext("errors", "must have the @ sign and no spaces")
      assert response =~ dgettext("errors", "should be at least %{count} character", count: 12)
      assert response =~ dgettext("errors", "does not match password")
      assert response =~ dgettext("errors", "can&#39;t be blank")
    end
  end

  defp flash_messages_contain(conn, text) do
    conn
    |> Phoenix.Controller.get_flash()
    |> Enum.any?(fn item -> String.contains?(elem(item, 1), text) end)
  end
end
