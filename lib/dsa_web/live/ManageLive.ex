defmodule DsaWeb.ManageLive do

  use Phoenix.LiveView
  require Logger

  alias Dsa.{Accounts, Event, Repo}

  @topic "manage"

  def render(assigns), do: DsaWeb.ManageView.render("manage.html", assigns)

  def mount(_params, %{"user_id" => user_id}, socket) do
    DsaWeb.Endpoint.subscribe(@topic)
    {:ok, socket
    |> assign(:changeset, nil)
    |> assign(:admin, Accounts.admin?(user_id))
    |> assign(:user_options, Accounts.list_user_options())
    |> assign(:user_id, user_id)}
  end

  def handle_info(%{event: "update"}, socket), do: handle_params(nil, nil, socket)

  def handle_params(_params, _session, socket) do
    case socket.assigns.live_action do
      :groups -> {:noreply, assign(socket, :entries, Accounts.list_groups())}
      :users -> {:noreply, assign(socket, :entries, Accounts.list_users())}
      _ -> {:noreply, assign(socket, :changeset, nil)}
    end
  end

  defp get_changeset(socket, struct, params \\ %{}) do
    case socket.assigns.live_action do
      :groups -> Accounts.change_group(struct, params)
      :users -> Accounts.change_user(struct, params)
    end
  end

  def handle_event("add", _params, socket) do
    changeset =
      case socket.assigns.live_action do
        :groups -> Accounts.change_group(%Accounts.Group{})
        :users -> Accounts.change_user(%Accounts.User{})
      end
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("edit", %{"id" => id}, socket) do
    {:noreply, assign(socket, :changeset, get_changeset(socket, entry(socket, id)))}
  end

  def handle_event("reset-password", %{"user" => id}, socket) do
    user = entry(socket, id)

    case Accounts.update_user(user, %{password: "password"}) do
      {:ok, user} ->
        Logger.debug("Password of #{user.name} has been reset to \"password\"")
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error(inspect changeset.errors)
        {:noreply, socket}
    end
  end

  def handle_event("toggle", %{"admin" => id}, socket) do
    user = entry(socket, id)

    case Accounts.update_user(user, %{admin: !user.admin}) do
      {:ok, user} ->
        DsaWeb.Endpoint.broadcast(@topic, "update", user)
        Logger.debug("#{user.name} is #{if user.admin, do: "now", else: "no longer"} an admin.")
        {:noreply, socket}

      {:error, changeset} ->
        Logger.error(inspect changeset.errors)
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"group" => params}, socket) do
    changeset = Accounts.change_group(socket.assigns.changeset.data, params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset = Accounts.change_user(socket.assigns.changeset.data, params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("remove-logs", %{"group" => id}, socket) do
    Event.delete_logs(id)
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    case Repo.insert_or_update(socket.assigns.changeset) do
      {:ok, entry} ->
        DsaWeb.Endpoint.broadcast(@topic, "update", entry)
        {:noreply, assign(socket, :changeset, nil)}

      {:error, changeset} ->
        Logger.error(inspect changeset.errors)
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Accounts.delete(entry(socket, id)) do
      {:ok, entry} ->
        DsaWeb.Endpoint.broadcast(@topic, "update", entry)
        Logger.debug("Entry added: #{entry.name}")
        {:noreply, socket}
      {:error, changeset} ->
        Logger.error("Error deleting entry: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :changeset, nil)}
  end

  defp entry(socket, id), do: Enum.find(socket.assigns.entries, & &1.id == String.to_integer(id))
end
