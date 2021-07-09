defmodule MapUtilitiesTest do
  use ExUnit.Case, async: true

  alias MapUtilities
  require Logger

  describe "deep_merge/2" do
    setup do
      %{
        default: %{"name" => "Ethric", "skills" => %{"1" => 2, "2" => 0}},
        overwrite: %{"age" => 12, "skills" => %{"2" => 3, "3" => 4}}
      }
    end

    test "merges two maps correctly", %{default: left, overwrite: right} do
      assert %{
        "age" => 12,
        "name" => "Ethric",
        "skills" => %{"1" => 2, "2" => 3, "3" => 4}
      } = MapUtilities.deep_merge(left, right)
    end
  end
end
