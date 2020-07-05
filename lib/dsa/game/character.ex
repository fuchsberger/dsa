defmodule Dsa.Game.Character do
  use Ecto.Schema
  import Ecto.Changeset

  @traits [:mu, :kl, :in, :ch, :ff, :ge, :ko, :kk]

  schema "characters" do

    # Generell
    field :name, :string
    field :ap, :integer, default: 1100
    field :species, :string, default: "Mensch"
    field :culture, :string
    field :profession, :string
    field :title, :string
    field :eyecolor, :string
    field :height, :integer
    field :weight, :integer
    field :birthplace, :string
    field :haircolor, :string
    field :created, :boolean, default: false

    # Eigenschaften
    field :mu, :integer, default: 8
    field :kl, :integer, default: 8
    field :in, :integer, default: 8
    field :ch, :integer, default: 8
    field :ff, :integer, default: 8
    field :ge, :integer, default: 8
    field :ko, :integer, default: 8
    field :kk, :integer, default: 8

    # Hilfsfelder
    field :ap_species, :integer, default: 0, virtual: true
    field :ap_remaining, :integer, default: 1100, virtual: true
    field :trait_points, :integer, default: 64, virtual: true
    field :max_trait_points, :integer, default: 100, virtual: true

    belongs_to :user, Dsa.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :species, :ap] ++ @traits)
    |> validate_required([:name, :species, :ap] ++ @traits)
    |> validate_trait(:mu)
    |> validate_trait(:kl)
    |> validate_trait(:in)
    |> validate_trait(:ch)
    |> validate_trait(:ff)
    |> validate_trait(:ge)
    |> validate_trait(:ko)
    |> validate_trait(:kk)
    |> validate_ap(:species)
    |> validate_ap(:remaining)
    |> set_max_trait_points()
    |> validate_traits()
  end

  defp validate_ap(character, :species) do
    ap_species =
      case get_field(character, :species) do
        "Elf" -> 18
        "Zwerg" -> 61
        _ -> 0
      end
    put_change(character, :ap_species, ap_species)
  end

  defp validate_ap(character, :remaining) do
    ap_remaining = get_field(character, :ap) - get_field(character, :ap_species)

    if ap_remaining <= 10 do
      put_change(character, :ap_remaining, ap_remaining)
    else
      character
      |> put_change(:ap_remaining, ap_remaining)
      |> add_error(:ap_remaining, "Die verbleibende Anzahl an AP darf 10 nicht überschreiten.")
    end
  end

  def validate_trait(character, trait) do
    max = max_trait(character)

    case { get_field(character, :species), trait} do
      {"Mensch", trait} ->
        validate_number character, trait,
          greater_than_or_equal_to: 8,
          less_than_or_equal_to: max + 1

      {"Halbelf", trait} ->
        validate_number character, trait,
          greater_than_or_equal_to: 8,
          less_than_or_equal_to: max + 1

      {"Elf", :in} ->
        validate_number character, trait,
          greater_than_or_equal_to: 8,
          less_than_or_equal_to: max + 1

      {"Elf", :ge} ->
        validate_number character, trait,
          greater_than_or_equal_to: 8,
          less_than_or_equal_to: max + 1

      {"Zwerg", :ko} ->
        validate_number character, trait,
          greater_than_or_equal_to: 8,
          less_than_or_equal_to: max + 1

      {"Zwerg", :kk} ->
        validate_number character, trait,
          greater_than_or_equal_to: 8,
          less_than_or_equal_to: max + 1

      {_species, _trait} ->
        validate_number(character, trait, greater_than_or_equal_to: 8, less_than_or_equal_to: max)
    end
  end

  defp max_trait(character) do
    if get_field(character, :generated) do
      999
    else
      case get_field(character, :ap) do
        900 -> 12
        1000 -> 13
        1100 -> 14
        1200 -> 15
        1400 -> 16
        1700 -> 17
        2100 -> 18
      end
    end
  end

  defp set_max_trait_points(character) do
    max =
      if get_field(character, :generated) do
        nil
      else
        case get_field(character, :ap) do
          900 -> 95
          1000 -> 98
          1100 -> 100
          1200 -> 102
          1400 -> 105
          1700 -> 109
          2100 -> 114
        end
      end
    put_change(character, :max_trait_points, max)
  end

  defp validate_traits(character) do
    trait_points = Enum.reduce(@traits, 0, fn x, acc -> acc + get_field(character, x) end)
    max_trait_points = get_field(character, :max_trait_points)

    if not is_nil(max_trait_points) && trait_points > max_trait_points do
      character
      |> put_change(:trait_points, trait_points)
      |> add_error(:trait_points, "Maximal #{max_trait_points} Punkte können auf Eigenschaften verteilt werden.")
    else
      put_change(character, :trait_points, trait_points)
    end
  end
end
