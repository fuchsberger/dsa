defmodule Dsa.Lists do
  @moduledoc """
  Contains frequently used lists.
  """

  @sf_values ~w(A B C D E)
  @base_values ~w(mu kl in ch ff ge ko kk)a
  @talent_categories ~w(Körper Gesellschaft Natur Wissen Handwerk Zauber Liturgie)

  def base_values, do: @base_values
  def base_value_options do
    Enum.map(@base_values, & {String.upcase(Atom.to_string(&1)), Atom.to_string(&1)})
  end

  def sf_values, do: @sf_values

  def talent_categories, do: @talent_categories

  def talent_categories(admin)
  def talent_categories(true), do: @talent_categories
  def talent_categories(false), do: ["Zauber", "Liturgie"]
end
