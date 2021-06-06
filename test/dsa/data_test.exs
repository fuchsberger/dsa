defmodule Dsa.DataTest do
  use Dsa.DataCase

  alias Dsa.Data

  describe "list_skills/0" do
    test "returns a list of 59 skills in correct order" do
      assert [] = skills =  Data.list_skills()
      assert Enum.count(skills) == 59

      assert %{id: 2} = Enum.at(skills, 1)
      assert %{id: 3} = Enum.at(skills, 2)
    end
  end


end
