defmodule Dsa do
  @moduledoc """
  Dsa keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def base_values, do: ~w(mu kl in ch ff ge ko kk)a

  @sf_values ~w(A B C D E)

  @talent_categories ~w(Körper Natur Gesellschaft Wissen Handwerk)

  # def base_value_options do
  #   Enum.map(@base_values, & {String.upcase(Atom.to_string(&1)), Atom.to_string(&1)})
  # end

  def combat_fields, do: Enum.map(1..21, & String.to_atom("c#{&1}"))

  def sf_values, do: @sf_values

  def talent_categories, do: @talent_categories
end
