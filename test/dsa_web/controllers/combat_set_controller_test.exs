defmodule DsaWeb.CombatSetControllerTest do
  use DsaWeb.ConnCase

  alias Dsa.Characters

  @create_attrs %{at: 10, aw: 6, base_ini: 10, be: 0, gs: 6, pa: 10, rs: 0, tp_bonus: 0, tp_dice: 1, tp_type: 6}
  @update_attrs %{at: 11, aw: 7, base_ini: 11, be: 1, gs: 7, pa: 11, rs: 1, tp_bonus: 1, tp_dice: 2, tp_type: 7}
  @invalid_attrs %{at: nil, aw: nil, base_ini: nil, be: nil, gs: nil, pa: nil, rs: nil, tp_bonus: nil, tp_dice: nil}

  # def fixture(:combat_set) do
  #   {:ok, combat_set} = Characters.create_combat_set(@create_attrs)
  #   combat_set
  # end

  # describe "index" do
  #   test "lists all combat_sets", %{conn: conn} do
  #     conn = get(conn, Routes.character_combat_set_path(conn, :index, @character))
  #     assert html_response(conn, 200) =~ "Listing Combat sets"
  #   end
  # end

  # describe "new combat_set" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.character_combat_set_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Combat set"
  #   end
  # end

  # describe "create combat_set" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.character_combat_set_path(conn, :create), combat_set: @create_attrs)

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.character_combat_set_path(conn, :show, id)

  #     conn = get(conn, Routes.character_combat_set_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Show Combat set"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.character_combat_set_path(conn, :create), combat_set: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "New Combat set"
  #   end
  # end

  # describe "edit combat_set" do
  #   setup [:create_combat_set]

  #   test "renders form for editing chosen combat_set", %{conn: conn, combat_set: combat_set} do
  #     conn = get(conn, Routes.character_combat_set_path(conn, :edit, combat_set))
  #     assert html_response(conn, 200) =~ "Edit Combat set"
  #   end
  # end

  # describe "update combat_set" do
  #   setup [:create_combat_set]

  #   test "redirects when data is valid", %{conn: conn, combat_set: combat_set} do
  #     conn = put(conn, Routes.character_combat_set_path(conn, :update, combat_set), combat_set: @update_attrs)
  #     assert redirected_to(conn) == Routes.character_combat_set_path(conn, :show, combat_set)

  #     conn = get(conn, Routes.character_combat_set_path(conn, :show, combat_set))
  #     assert html_response(conn, 200)
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, combat_set: combat_set} do
  #     conn = put(conn, Routes.character_combat_set_path(conn, :update, combat_set), combat_set: @invalid_attrs)
  #     assert html_response(conn, 200) =~ "Edit Combat set"
  #   end
  # end

  # describe "delete combat_set" do
  #   setup [:create_combat_set]

  #   test "deletes chosen combat_set", %{conn: conn, combat_set: combat_set} do
  #     conn = delete(conn, Routes.character_combat_set_path(conn, :delete, combat_set))
  #     assert redirected_to(conn) == Routes.character_combat_set_path(conn, :index)
  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.character_combat_set_path(conn, :show, combat_set))
  #     end
  #   end
  # end

  # defp create_combat_set(_) do
  #   combat_set = fixture(:combat_set)
  #   %{combat_set: combat_set}
  # end
end
