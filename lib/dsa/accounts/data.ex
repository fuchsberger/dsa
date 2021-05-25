defmodule Dsa.Data do
  @moduledoc """
  The Data context.
  """
  import Ecto.Query, warn: false
  alias Dsa.Repo
  alias Dsa.Data.Skill

  @doc """
  Gets all skills ordered by category and then name.

  ## Examples

      iex> list_skills!()
      [%Skill{}]

  """
  def list_skills do
    from(s in Skill, order_by: [s.category, s.name])
    |> Repo.all()
  end

  ## Skills

  @doc """
  Creates a skill.

  ## Examples

      iex> create_skill(%{field: value})
      {:ok, %Skill{}}

      iex> create_skill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_skill(attrs) do
    %Skill{}
    |> Skill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a skill.

  ## Examples

      iex> update_skill(%Skill{}, %{field: value})
      {:ok, %Skill{}}

      iex> update_skill(%Skill{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_skill(%Skill{} = skill, attrs) do
    skill
    |> Skill.changeset(attrs)
    |> Repo.update()
  end
end
