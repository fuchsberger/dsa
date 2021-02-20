defmodule DsaWeb.LiveHelpers do

  use Phoenix.HTML
  import Phoenix.LiveView

  alias Dsa.Accounts
  alias DsaWeb.LiveView

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

    new_entry =
      character
      |> Ecto.build_assoc(type)
      |> Map.put(id_field(type), String.to_integer(id))

    changeset = Ecto.Changeset.put_assoc(changeset, type, [
      new_entry | Ecto.Changeset.get_field(changeset, type)
    ])

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def edit(type, socket) do
    changeset = Accounts.change_character_assoc(socket.assigns.character, %{}, type)
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

  def validate(type, %{"character" => params}, socket) do
    changeset = Accounts.change_character_assoc(socket.assigns.character, params, type)
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

  def id_field(type) do
    type
    |> Atom.to_string()
    |> String.slice(0..-2)
    |> Kernel.<>("_id")
    |> String.to_atom()
  end

  # def buttons(target) do
  #   ~E"""
  #     <div class="buttons are-small is-centered">
  #       <button type='submit' class='button is-info py-0 mb-1 h-auto'>
  #         <span class='icon mr-1'><i class='icon-ok'></i></span> speichern
  #       </button>
  #       <button class='button is-light py-0 mb-1 h-auto' phx-click='cancel' phx-target='<%= target %>' type='button'>
  #         <span class='icon mr-1'><i class='icon-cancel'></i></span> abbrechen
  #       </button>
  #     </div>
  #   """
  # end
end
