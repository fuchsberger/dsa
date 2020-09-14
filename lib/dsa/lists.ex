defmodule Dsa.Lists do
  @moduledoc """
  Contains frequently used lists.
  """

  @sf_values ~w(A B C D E)
  @base_values ~w(mu kl in ch ff ge ko kk)a

  @talent_categories ~w(Körper Natur Gesellschaft Wissen Handwerk)

  def base_values, do: @base_values
  def base_value_options do
    Enum.map(@base_values, & {String.upcase(Atom.to_string(&1)), Atom.to_string(&1)})
  end

  def combat_fields, do: Enum.map(1..21, & String.to_atom("c#{&1}"))

  def sf_values, do: @sf_values

  def talent_categories, do: @talent_categories

  def talent_fields, do: Enum.map(1..58, & String.to_atom("t#{&1}"))
end
