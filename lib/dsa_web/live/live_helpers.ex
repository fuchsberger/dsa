defmodule DsaWeb.LiveHelpers do

  import Phoenix.LiveView

  alias Dsa.Accounts

  require Logger

  @doc """
  Assigns current user to socket when mounting live views.
  Ensure this is done before any other assigns that require the user.
  """
  def assign_defaults(%{"user_id" => user_id} = _session, socket) do
    socket = assign_new(socket, :current_user, fn -> Accounts.get_user!(user_id) end)

    if socket.assigns.current_user do
      socket
    else
      redirect(socket, to: "/login")
    end
  end

  def add(type, %{"entry" => %{"id" => id}}, socket) do
    %{character: character, changeset: changeset} = socket.assigns

    id_field =
      type
      |> Atom.to_string()
      |> String.slice(0..-2)
      |> Kernel.<>("_id")
      |> String.to_atom()

    new_entry = character |> Ecto.build_assoc(type) |> Map.put(id_field, String.to_integer(id))

    changeset = Ecto.Changeset.put_assoc(changeset, type, [
      new_entry | Ecto.Changeset.get_field(changeset, type)
    ])

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def save(type, %{"character" => params}, socket) do
    params = if Map.has_key?(params, Atom.to_string(type)), do: params, else: nil

    case Accounts.update_character_assocs(socket.assigns.character, params, type) do
      {:ok, character} ->
        Logger.debug("#{String.capitalize(Atom.to_string(type))} updated.")
        send self(), {:updated_character, Accounts.preload(character)}
        {:noreply, assign(socket, changeset: nil)}

      {:error, changeset} ->
        Logger.debug("#{String.capitalize(Atom.to_string(type))} error: #{inspect(changeset)}")
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
