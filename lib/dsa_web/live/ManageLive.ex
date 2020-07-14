defmodule DsaWeb.ManageLive do

  use Phoenix.LiveView

  alias Dsa.{Accounts, Lore, Repo}

  def render(assigns), do: DsaWeb.ManageView.render("manage.html", assigns)

  def mount(_params, _session, socket) do
    {:ok, socket
    |> assign(:changeset, nil)
    |> assign(:entries, get_entries(socket))}
  end

  def handle_params(_params, _session, socket) do
    {:noreply, socket
    |> assign(:changeset, nil)
    |> assign(:entries, get_entries(socket))}
  end

  defp get_changeset(socket) do
    case socket.assigns.live_action do
      :groups -> Accounts.change_group()
      :skills -> Lore.change_skill()
      :users -> Accounts.change_registration()
    end
  end

  defp get_changeset(socket, struct, params \\ %{}) do
    case socket.assigns.live_action do
      :groups -> Accounts.change_group(struct, params)
      :skills -> Lore.change_skill(struct, params)
      :users -> Accounts.change_registration(struct, params)
    end
  end

  defp get_entries(socket) do
    case socket.assigns.live_action do
      :groups -> Accounts.list_groups()
      :skills -> Lore.list_skills()
      :users -> Accounts.list_users()
    end
  end

  def handle_event("add", _params, socket) do
    {:noreply, assign(socket, :changeset, get_changeset(socket))}
  end

  def handle_event("edit", %{"id" => id}, socket) do
    entry = Enum.find(socket.assigns.entries, & &1.id == String.to_integer(id))
    {:noreply, assign(socket, :changeset, get_changeset(socket, entry))}
  end

  def handle_event("validate", %{"entry" => params}, socket) do
    changeset = get_changeset(socket, socket.assigns.changeset.data, params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"entry" => params}, socket) do
    changeset = get_changeset(socket, socket.assigns.changeset.data, params)

    case Repo.insert_or_update(changeset) do
      {:ok, _user} ->
        {:noreply, socket
        |> assign(:changeset, nil)
        |> assign(:entries, get_entries(socket))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    socket.assigns.entries
    |> Enum.find(& &1.id == String.to_integer(id))
    |> Repo.delete!()

    {:noreply, assign(socket, :entries, get_entries(socket))}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :changeset, nil)}
  end
end
