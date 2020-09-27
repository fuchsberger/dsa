defmodule AdvantagesComponent do
  use DsaWeb, :live_component

  import DsaWeb.CharacterHelpers, only: [ap: 2]

  alias Dsa.Accounts
  alias Dsa.Data.Advantage

  @changeset_type :advantages

  def mount(socket) do
    {:ok, socket
    |> assign(:changeset, nil)
    |> assign(:options, Advantage.options([]))}
  end

  def handle_event("add", %{"entry" => %{"id" => id}}, socket) do
    id = String.to_integer(id)
    %{character: c, changeset: changeset} = socket.assigns

    advantages = [
      Ecto.build_assoc(c, @changeset_type, id: id) | Ecto.Changeset.get_field(changeset, :advantages)
    ]

    {:noreply, socket
    |> assign(:changeset, Ecto.Changeset.put_assoc(changeset, :advantages, advantages))
    |> assign(:options, Advantage.options(advantages))}
  end

  def handle_event("cancel", _params, socket), do: {:noreply, assign(socket, :changeset, nil)}

  def handle_event("edit", _params, socket) do
    changeset = Accounts.change_character_assoc(socket.assigns.character, %{}, @changeset_type)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("validate", %{"character" => params}, socket) do
    changeset = Accounts.change_character_assoc(socket.assigns.character, params, @changeset_type)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("remove", %{"id" => id}, socket) do
    id = String.to_integer(id)
    advantages =
      socket.assigns.changeset
      |> Ecto.Changeset.get_field(:advantages)
      |> Enum.reject(& &1.id == id)

    changeset = Ecto.Changeset.put_assoc(socket.assigns.changeset, :advantages, advantages)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", params, socket), do: save(@changeset_type, params, socket)

  def render(%{changeset: nil} = assigns) do
  ~L"""
    <div class="card px-0 my-2">
      <header class="card-header">
        <button class='button is-white px-3 py-0 h-auto' phx-target="<%= @myself %>" phx-click='edit' type='button'>
          <span class='icon has-text-link'><i class='icon-edit'></i></span>
        </button>
        <p class='card-header-title pl-0 py-0'>Vorteile</p>
        <span class='tag is-light my-1 mr-1'>
          <strong><%= ap(@character, :advantages) %></strong>
          &nbsp;AP
        </span>
      </header>
      <div class="card-content px-1 py-2">
        <%= Enum.map(@character.advantages, & Advantage.name(&1.id)) |> Enum.join(", ") %>
        <%= if Enum.count(@character.advantages) == 0 do %>
          <%= @character.name %> hat keine besonderen Vorteile.
        <% end %>
      </div>
    </div>
  """
  end

  def render(assigns) do
    ~L"""
      <div class="card px-0 my-2">
        <header class="card-header">
          <p class='card-header-title pl-2 py-0'>Vorteile</p>
          <form phx-change='add' phx-target='<%= @myself %>'>
            <%= Phoenix.HTML.Form.select :entry, :id, @options,
              class: "select is-small py-1 h-auto is-fullwidth",
              prompt: "hinzufügen..."
            %>
          </form>
        </header>

        <div class='card-content px-0 pt-2 pb-0'>
          <%=
            f = form_for @changeset, "#", [
              id: "advantages-form",
              phx_change: :validate,
              phx_submit: :save,
              phx_target: @myself,
              novalidate: true
            ]
          %>
          <%= hidden_inputs_for(f) %>
            <table class='table is-size-7 is-fullwidth mb-1'>
              <thead>
                <tr>
                  <th>Name</th>
                  <th class='has-text-centered'>AP</th>
                  <th class='has-text-centered'>
                    <div class='icon is-small'><i class='icon-remove'></i></div>
                  </th>
                </tr>
              </thead>
              <tbody>
                <%= for fs <- inputs_for(f, :advantages) do %>
                  <% id = input_value(fs, :id) %>
                  <tr>
                    <td><%= Advantage.name(id) %><%= hidden_inputs_for(fs) %></td>
                    <td class='has-text-centered'><%= Advantage.ap(id) %></td>
                    <td class='has-text-centered py-0'>
                      <button
                        type='button'
                        class='button is-small py-0 px-0 h-auto is-white'
                        phx-click='remove'
                        phx-value-id='<%= id %>'
                        phx-target="<%= @myself %>"
                      ><i class='icon-cancel has-text-danger'></i></button>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
            <div class="buttons are-small is-centered">
              <button type='submit' class='button is-info py-0 mb-1 h-auto'>
                <span class='icon mr-1'><i class='icon-ok'></i></span> speichern
              </button>
              <button class='button is-light py-0 mb-1 h-auto' phx-click='cancel' phx-target='<%= @myself %>' type='button'>
                <span class='icon mr-1'><i class='icon-cancel'></i></span> abbrechen
              </button>
            </div>
          </form>
        </div>
      </div>
    """
  end
end
