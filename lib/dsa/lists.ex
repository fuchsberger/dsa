defmodule Dsa.Lists do
  @moduledoc """
  Contains frequently used lists.
  """

  @sf_values ~w(A B C D E)
  @base_values ~w(MU KL IN CH FF GE KO KK)a
  @talent_categories ~w(Körper Gesellschaft Natur Wissen Handwerk Zauber Liturgie)

  def base_values, do: @base_values
  def base_value_options, do: Enum.map(@base_values, & Atom.to_string(&1))

  def sf_values, do: @sf_values
  def talent_categories, do: @talent_categories
end
