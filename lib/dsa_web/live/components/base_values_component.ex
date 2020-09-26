defmodule BaseValuesComponent do
  use DsaWeb, :live_component

  import DsaWeb.CharacterHelpers, only: [ap: 2]

  alias Dsa.Accounts
  alias Dsa.Lists

  @changeset_type :base_values

  def mount(socket) do
    {:ok, socket
    |> assign(:changeset, nil)
    |> assign(:base_values, Lists.base_values())}
  end

  def handle_event("edit", _params, socket) do
    changeset = Accounts.change_character(socket.assigns.character, %{}, @changeset_type)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("validate", %{"character" => params}, socket) do
    changeset =
      socket.assigns.character
      |> Accounts.change_character(params, @changeset_type)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"character" => character_params}, socket) do
    case Accounts.update_character(socket.assigns.character, character_params, @changeset_type) do
      {:ok, character} ->
        Logger.debug("Base values updated.")
        send self(), {:updated_character, Accounts.preload(character)}
        {:noreply, assign(socket, changeset: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def render(%{changeset: nil} = assigns) do
    ~L"""
    <div class='columns mb-1'>
      <div class='column py-0'>
        <button class='button is-white px-3 py-0 h-auto' phx-target="<%= @myself %>" phx-click='edit' phx-value-edit='advantages' type='button'>
          <span class='icon has-text-link'><i class='icon-edit'></i></span>
        </button>
      </div>
      <%= for field <- @base_values do %>
        <div class='column py-0'>
          <span class='tag is-primary is-light'>
            <strong><%= String.upcase(Atom.to_string(field)) %></strong>:
            <%= Map.get(@character, field) %>
          </span>
        </div>
      <% end %>
      <div class='column py-0'>
        <span class='tag is-light my-0 mr-1'>
          <strong><%= ap(@character, :base_values) %></strong>
          &nbsp;AP
        </span>
      </div>
    </div>
    """
  end

  def render(assigns) do
    ~L"""
    <%=
      f = form_for @changeset, "#", [
        id: "general-form",
        phx_change: :validate,
        phx_submit: :save,
        phx_target: @myself,
        novalidate: true
      ]
    %>
      <div class='columns mb-0'>
        <div class='column'>
          <button class='button is-white px-3 py-0 h-auto' type='submit'>
            <span class='icon has-text-link'>
              <i class='icon-ok'></i>
            </span>
          </button>
        </div>
        <%= for field <- @base_values do %>
          <div class='column py-0'>
            <div class="field is-expanded">
              <div class="field has-addons">
                <p class='control'>
                  <%= label f, field, String.upcase(Atom.to_string(field)), class: "button is-small is-static has-text-weight-bold px-1" %>
                </p>
                <p class="control">
                  <%= text_input f, field, class: "input is-small has-text-centered" %>
                </p>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </form>
    """
  end
end
