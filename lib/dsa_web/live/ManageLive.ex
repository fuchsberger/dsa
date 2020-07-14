defmodule DsaWeb.ManageLive do

  use Phoenix.LiveView

  alias Dsa.{Accounts, Repo}

  def render(assigns), do: DsaWeb.ManageView.render("manage.html", assigns)

  def mount(_params, %{"user_id" => user_id}, socket) do

    users = Accounts.list_users()

    {:ok, socket
    |> assign(:admin?, Enum.find(users, & &1.id == user_id).admin)
    |> assign(:changeset, nil)
    |> assign(:users, users)}
  end

  def handle_event("add", _params, socket) do
    changeset = Accounts.change_registration(%Accounts.User{}, %{})
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("edit", %{"user" => id}, socket) do
    user = Enum.find(socket.assigns.users, & &1.id == String.to_integer(id))
    changeset = Accounts.change_registration(user, %{})
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset = Accounts.change_registration(socket.assigns.changeset.data, params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    changeset = Accounts.change_registration(socket.assigns.changeset.data, params)

    case Repo.insert_or_update(changeset) do
      {:ok, _user} ->
        {:noreply, socket
        |> assign(:changeset, nil)
        |> assign(:users, Accounts.list_users())}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("delete", %{"user" => id}, socket) do
    socket.assigns.users |> Enum.find(& &1.id == String.to_integer(id)) |> Accounts.delete_user!()
    {:noreply, assign(socket, :users, Accounts.list_users())}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :changeset, nil)}
  end
end
