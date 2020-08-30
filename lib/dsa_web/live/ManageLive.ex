defmodule DsaWeb.ManageLive do

  use Phoenix.LiveView
  require Logger

  alias Dsa.{Accounts, Lore, Event, Repo}

  @topic "manage"

  def handle_info(%{event: "save-entry", payload: %{id: id} = entry}, socket) do
    case entry do
      %Lore.Armor{} ->
        groups =
          socket.assigns.armors
          |> Enum.reject(& &1.id == id)
          |> Enum.concat([entry])
          |> Enum.sort_by(& &1.name)
        {:noreply, assign(socket, :armors, groups)}

      %Lore.Skill{} ->
        skills =
          socket.assigns.skills
          |> Enum.reject(& &1.id == id)
          |> Enum.concat([entry])
          |> Enum.sort_by(& {&1.category, &1.name})
        {:noreply, assign(socket, :skills, skills)}

      %Accounts.Group{} ->
        groups =
          socket.assigns.groups
          |> Enum.reject(& &1.id == id)
          |> Enum.concat([entry])
          |> Enum.sort_by(& &1.name)
        {:noreply, assign(socket, :groups, groups)}

      %Accounts.User{} ->
        users =
          socket.assigns.users
          |> Enum.reject(& &1.id == id)
          |> Enum.concat([entry])
          |> Enum.sort_by(& &1.name)
        {:noreply, assign(socket, :users, users)}
    end
  end

  def handle_info(%{event: "remove-entry", payload: %{id: id} = entry}, socket) do
    case entry do
      %Lore.Armor{} ->
        {:noreply, assign(socket, :armors, Enum.reject(socket.assigns.armors, & &1.id == id))}

      %Lore.Skill{} ->
        {:noreply, assign(socket, :skills, Enum.reject(socket.assigns.skills, & &1.id == id))}

      %Accounts.Group{} ->
        {:noreply, assign(socket, :groups, Enum.reject(socket.assigns.groups, & &1.id == id))}

      %Accounts.User{} ->
        {:noreply, assign(socket, :users, Enum.reject(socket.assigns.users, & &1.id == id))}
    end
  end

  def render(assigns), do: DsaWeb.ManageView.render("manage.html", assigns)

  def mount(_params, _session, socket) do

    DsaWeb.Endpoint.subscribe(@topic)

    {:ok, socket
    |> assign(:changeset, nil)
    |> assign(:armors, Lore.list_armors())
    |> assign(:skills, Lore.list_skills())
    |> assign(:groups, Accounts.list_groups())
    |> assign(:users, Accounts.list_users())}
  end

  def handle_params(_params, _session, socket) do
    {:noreply, socket}
  end

  defp get_changeset(socket) do
    case socket.assigns.live_action do
      :armors -> Lore.change_armor()
      :groups -> Accounts.change_group()
      :skills -> Lore.change_skill()
      :users -> Accounts.change_registration()
    end
  end

  defp get_changeset(socket, struct, params \\ %{}) do
    case socket.assigns.live_action do
      :armors -> Lore.change_armor(struct, params)
      :groups -> Accounts.change_group(struct, params)
      :skills -> Lore.change_skill(struct, params)
      :users -> Accounts.change_registration(struct, params)
    end
  end

  def handle_event("add", _params, socket) do
    {:noreply, assign(socket, :changeset, get_changeset(socket))}
  end

  def handle_event("edit", %{"id" => id}, socket) do


    entry = Enum.find(Map.get(socket.assigns, socket.assigns.live_action), & &1.id == String.to_integer(id))
    {:noreply, assign(socket, :changeset, get_changeset(socket, entry))}
  end

  def handle_event("validate", %{"entry" => params}, socket) do
    changeset = get_changeset(socket, socket.assigns.changeset.data, params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("remove-logs", %{"group" => id}, socket) do
    Event.delete_logs(id)
    {:noreply, socket}
  end

  def handle_event("save", %{"entry" => params}, socket) do
    changeset = get_changeset(socket, socket.assigns.changeset.data, params)

    case Repo.insert_or_update(changeset) do
      {:ok, entry} ->
        DsaWeb.Endpoint.broadcast(@topic, "save-entry", entry)
        {:noreply, assign(socket, :changeset, nil)}

      {:error, changeset} ->
        Logger.error(inspect changeset.errors)
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do

    entry =
      case socket.assigns.live_action do
        :groups -> socket.assigns.groups
        :skills -> socket.assigns.skills
        :users -> socket.assigns.users
      end
      |> Enum.find(& &1.id == String.to_integer(id))
      |> Repo.delete!()

    DsaWeb.Endpoint.broadcast(@topic, "remove-entry", entry)
    {:noreply, socket}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :changeset, nil)}
  end
end
