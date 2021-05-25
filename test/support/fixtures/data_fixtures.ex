defmodule Dsa.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating entities via the `Dsa.Data` context.
  """
  alias Dsa.Data

  def valid_skill_attributes(attrs \\ %{}) do
    id = System.unique_integer([:positive])

    Enum.into(attrs, %{
      id: id,
      name: "Skill #{id}",
      category: "Handwerkstalente",
      check: "MU/KL/FF",
      applications: ["alchimistische Gifte", "Elixiere", "profane Alchimie"],
      encumbrance_default: true,
      encumbrance_conditional: nil,
      tools: "alchimistisches Labor",
      quality: "Der Trank weist eine bessere Qualität auf.",
      failure: "Das Elixier ist misslungen oder eine Analyse hat kein Ergebnis gebracht.",
      success: "Der Held weiß exakt, welches Elixier er vor sich hat, welche Stufe es besitzt und wie lange haltbar es ist.",
      botch: "Das Elixier sorgt für einen unangenehmen Nebeneffekt.",
      cost_factor: "C",
      book: "Basis Regelwerk",
      page: 206,
      description: "Mit der alten Kunst der Alchimie lassen sich sowohl wundersame Tinkturen als auch profane Substanzen wie Seifen, Glas und Porzellan, Farben und Lacke analysieren und herstellen.\nZur Herstellung von Elixieren und Tränken benötigt der Alchimist meist aufwendig aufzutreibende Grundstoffe, das richtige Rezept und ein Labor. Viele Alchimisten werden argwöhnisch betrachtet, da man befürchtet, sie könnten bei ihren verrückten Experimenten ihre Werkstätten in Brand setzen und giftige Wolken oder bestialischen Gestank produzieren."
    })
  end

  def skill_fixture(attrs \\ %{}) do
    {:ok, skill} =
      attrs
      |> valid_skill_attributes()
      |> Data.create_skill()

    skill
  end
end
