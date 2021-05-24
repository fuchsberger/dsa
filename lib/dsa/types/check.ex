defmodule Dsa.Type.Check do
  use Ecto.Type

  def type, do: :integer

  @traits ~w(MU KL IN CH FF GE KO KK)
  @traits_a ~w(mu kl in ch ff ge ko kk)a

  require Logger

  @doc """
  Converts a check (for example "MU/MU/KL") into an integer (reversible)
  """
  def cast(check) when is_binary(check) do
    with [t1, t2, t3] <- String.split(check, "/"),
      n1 when not is_nil(n1) <- Enum.find_index(@traits, & &1 == t1),
      n2 when not is_nil(n2) <- Enum.find_index(@traits, & &1 == t2),
      n3 when not is_nil(n3) <- Enum.find_index(@traits, & &1 == t3)
    do
      {:ok, n1 * 64 + n2 * 8 + n3}
    else
      _ -> :error
    end
  end

  def cast(_), do: :error

  @doc """
  Converts data from database back into a check (for example "MU/MU/KL") (reverse of cast)
  """
  def load(data) do
    {n1, data} = {div(data, 64), rem(data, 64)}
    {n2, n3} = {div(data, 8), rem(data, 8)}
    {:ok, "#{Enum.at(@traits, n1)}/#{Enum.at(@traits, n2)}/#{Enum.at(@traits, n3)}"}
  end

  def atomize(check) when is_binary(check) do
    with [t1, t2, t3] <- String.split(check, "/"),
      n1 when not is_nil(n1) <- Enum.find_index(@traits, & &1 == t1),
      n2 when not is_nil(n2) <- Enum.find_index(@traits, & &1 == t2),
      n3 when not is_nil(n3) <- Enum.find_index(@traits, & &1 == t3)
    do
      {:ok, {Enum.at(@traits_a, n1), Enum.at(@traits_a, n2), Enum.at(@traits_a, n3)}}
    else
      _ -> {:error, :invalid_check}
    end
  end

  def dump(:integer, val), do: {:ok, val}

  def dump(_), do: :error
end