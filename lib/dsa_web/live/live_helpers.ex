defmodule DsaWeb.LiveHelpers do

  use Phoenix.HTML
  import Phoenix.LiveView

  alias Dsa.Accounts
  alias DsaWeb.Router.Helpers, as: Routes

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
      redirect(socket, to: Routes.user_session_path(socket, :new))
    end
  end

  def add(type, %{"entry" => %{"id" => id}}, socket) do
    %{character: character, changeset: changeset} = socket.assigns

    new_entry =
      character
      |> Ecto.build_assoc(type)
      |> Map.put(id_field(type), String.to_integer(id))

    changeset = Ecto.Changeset.put_assoc(changeset, type, [
      new_entry | Ecto.Changeset.get_field(changeset, type)
    ])

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def cancel(socket), do: {:noreply, assign(socket, :changeset, nil)}

  def remove(type, %{"id" => id}, socket) do
    entries =
      socket.assigns.changeset
      |> Ecto.Changeset.get_field(type)
      |> Enum.reject(& Map.get(&1, id_field(type)) == String.to_integer(id))

    changeset = Ecto.Changeset.put_assoc(socket.assigns.changeset, type, entries)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def id_field(type) do
    type
    |> Atom.to_string()
    |> String.slice(0..-2)
    |> Kernel.<>("_id")
    |> String.to_atom()
  end
end
