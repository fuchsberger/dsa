defmodule ScriptComponent do
  use DsaWeb, :live_component

  import DsaWeb.CharacterHelpers, only: [ap: 2]

  alias Dsa.Data.Script

  @changeset_type :scripts

  def mount(socket), do: {:ok, assign(socket, :changeset, nil)}

  def handle_event("add", params, socket), do: add(@changeset_type, params, socket)

  def handle_event("cancel", _params, socket), do: cancel(socket)

  def handle_event("edit", _params, socket), do: edit(@changeset_type, socket)

  def handle_event("validate", params, socket), do: validate(@changeset_type, params, socket)

  def handle_event("remove", params, socket), do: remove(@changeset_type, params, socket)

  def handle_event("save", params, socket), do: save(@changeset_type, params, socket)

  def render(%{changeset: nil} = assigns) do
  ~L"""
    <div class="card px-0 my-2">
      <header class="card-header">
        <button class='button is-white px-3 py-0 h-auto' phx-target="<%= @myself %>" phx-click='edit' type='button'>
          <span class='icon has-text-link'><i class='icon-edit'></i></span>
        </button>
        <p class='card-header-title pl-0 py-0'>Schriften</p>
        <span class='tag is-light my-1 mr-1'>
          <strong><%= ap(@character, :scripts) %></strong>
          &nbsp;AP
        </span>
      </header>
      <div class="card-content px-1 py-2">
        <%=
          @character.scripts
          |> Enum.map(& Script.name(&1.script_id))
          |> Enum.join(", ")
        %>
        <%= if Enum.count(@character.scripts) == 0 do %>
          <%= @character.name %> ist ein Analphabet.
        <% end %>
      </div>
    </div>
  """
  end

  def render(assigns) do
    ~L"""
      <div class="card px-0 my-2">
        <header class="card-header">
          <p class='card-header-title pl-2 py-0'>Schriften</p>
          <form phx-change='add' phx-target='<%= @myself %>'>
            <%= Phoenix.HTML.Form.select :entry, :id, Script.options(@changeset),
              class: "select is-small py-1 h-auto is-fullwidth",
              prompt: "hinzufügen..."
            %>
          </form>
        </header>

        <div class='card-content px-0 pt-2 pb-0'>
          <%=
            f = form_for @changeset, "#", [
              id: "scripts-form",
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
                <%= for fs <- inputs_for(f, :scripts) do %>
                  <%
                    id = input_value(fs, :script_id)
                    id = if is_integer(id), do: id, else: String.to_integer(id)
                  %>
                  <tr>
                    <%= hidden_inputs_for(fs) %>
                    <td><%= Script.name(id) %></td>
                    <td class='has-text-centered'><%= Script.ap(id) %></td>
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
            <%= buttons(@myself) %>
          </form>
        </div>
      </div>
    """
  end
end
