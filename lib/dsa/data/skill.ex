defmodule Dsa.Data.Skill do
  use Ecto.Schema

  import Ecto.Changeset
  import DsaWeb.DsaHelpers, only: [traits: 0]

  alias Dsa.Type.{SkillCategory, Probe}

  @sf_values ~w(A B C D E)a

  schema "skills" do
    field :name, :string
    field :be, :boolean
    field :category, SkillCategory
    field :probe, Probe
    field :sf, Ecto.Enum, values: @sf_values
    field :t1, Ecto.Enum, values: traits(), virtual: true
    field :t2, Ecto.Enum, values: traits(), virtual: true
    field :t3, Ecto.Enum, values: traits(), virtual: true
  end

  @fields ~w(name sf category t1 t2 t3)a

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:be | @fields])
    |> validate_required(@fields)
    |> validate_length(:name, min: 5, max: 30)
    |> validate_number(:category, greater_than_or_equal_to: 0, less_than: SkillCategory.count())
    |> validate_number(:probe, greater_than_or_equal_to: 0, less_than_or_equal_to: 512)
    |> validate_inclusion(:t1, traits())
    |> validate_inclusion(:t2, traits())
    |> validate_inclusion(:t3, traits())
    |> validate_inclusion(:sf, @sf_values)
    |> validate_probe()
    |> unique_constraint(:name)
  end

  defp validate_probe(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{t1: t1, t2: t2, t3: t3}} ->
        put_change(changeset, :probe, {t1, t2, t3})

      _ ->
        changeset
    end
  end
end
