defmodule DsaWeb.SkillControllerTest do
  use DsaWeb.ConnCase

#   alias Dsa.Data

#   @create_attrs %{be: true, name: "some name"}
#   @update_attrs %{be: false, name: "some updated name"}
#   @invalid_attrs %{be: nil, name: nil}

#   def fixture(:skill) do
#     {:ok, skill} = Data.create_skill(@create_attrs)
#     skill
#   end

  describe "GET /skills" do
    test "lists all skills", %{conn: conn} do
      conn = get conn, "/skills"
      assert html_response(conn, 200) =~ "<h2 class='leading-8 text-xl font-bold'>Talente</h2>"
    end

    test "shows new skill button for admins", %{conn: conn} do
      user = user_fixture(%{admin: true})
      conn = assign conn, :current_user, user
      conn = get conn, "/skills"

      assert html_response(conn, 200) =~ "/skills/new"
    end
  end

#   describe "new skill" do
#     test "renders form", %{conn: conn} do
#       conn = get(conn, Routes.skill_path(conn, :new))
#       assert html_response(conn, 200) =~ "New Skill"
#     end
#   end

#   describe "create skill" do
#     test "redirects to show when data is valid", %{conn: conn} do
#       conn = post(conn, Routes.skill_path(conn, :create), skill: @create_attrs)

#       assert %{id: id} = redirected_params(conn)
#       assert redirected_to(conn) == Routes.skill_path(conn, :show, id)

#       conn = get(conn, Routes.skill_path(conn, :show, id))
#       assert html_response(conn, 200) =~ "Show Skill"
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, Routes.skill_path(conn, :create), skill: @invalid_attrs)
#       assert html_response(conn, 200) =~ "New Skill"
#     end
#   end

#   describe "edit skill" do
#     setup [:create_skill]

#     test "renders form for editing chosen skill", %{conn: conn, skill: skill} do
#       conn = get(conn, Routes.skill_path(conn, :edit, skill))
#       assert html_response(conn, 200) =~ "Edit Skill"
#     end
#   end

#   describe "update skill" do
#     setup [:create_skill]

#     test "redirects when data is valid", %{conn: conn, skill: skill} do
#       conn = put(conn, Routes.skill_path(conn, :update, skill), skill: @update_attrs)
#       assert redirected_to(conn) == Routes.skill_path(conn, :show, skill)

#       conn = get(conn, Routes.skill_path(conn, :show, skill))
#       assert html_response(conn, 200) =~ "some updated name"
#     end

#     test "renders errors when data is invalid", %{conn: conn, skill: skill} do
#       conn = put(conn, Routes.skill_path(conn, :update, skill), skill: @invalid_attrs)
#       assert html_response(conn, 200) =~ "Edit Skill"
#     end
#   end

#   describe "delete skill" do
#     setup [:create_skill]

#     test "deletes chosen skill", %{conn: conn, skill: skill} do
#       conn = delete(conn, Routes.skill_path(conn, :delete, skill))
#       assert redirected_to(conn) == Routes.skill_path(conn, :index)
#       assert_error_sent 404, fn ->
#         get(conn, Routes.skill_path(conn, :show, skill))
#       end
#     end
#   end

#   defp create_skill(_) do
#     skill = fixture(:skill)
#     %{skill: skill}
#   end
end
