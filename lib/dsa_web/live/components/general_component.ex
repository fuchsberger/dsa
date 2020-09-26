defmodule GeneralComponent do
  use DsaWeb, :live_component

  alias Dsa.Accounts
  alias Dsa.Data.Species

  @changeset_type :general

  def mount(socket) do
    {:ok, socket
    |> assign(:changeset, nil)
    |> assign(:species_options, Species.options())}
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
        Logger.debug("General Character Data updated.")
        send self(), {:updated_character, Accounts.preload(character)}
        {:noreply, assign(socket, changeset: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def render(%{changeset: nil} = assigns), do:
  ~L"""
    <div class="card px-0 py-0">
      <header class="card-header">
        <button class='button is-white px-3 py-0 h-auto' phx-target="<%= @myself %>" phx-click='edit' phx-value-edit='advantages' type='button'>
          <span class='icon has-text-link'><i class='icon-edit'></i></span>
        </button>
        <p class='card-header-title pl-0 py-0'>Persönliche Daten</p>
        <span class='tag is-light my-1 mr-1'>
          <strong><%= Species.ap(@character.species_id) %></strong>
          &nbsp;AP
        </span>
      </header>

      <div class="card-content px-1 py-2">
        <div class='columns mb-0'>
          <div class='column is-2 pt-2 is-size-7'><strong>Name</strong></div>
          <div class='column is-4'><%= @character.name %></div>
          <div class='column is-2 pt-2 is-size-7'><strong>Titel</strong></div>
          <div class='column is-4'><%= @character.title %></div>
        </div>
        <div class='columns mb-0'>
          <div class='column is-2 pt-2 is-size-7'><strong>Größe</strong></div>
          <div class='column is-4'>
            <%= @character.height && "#{@character.height} Schritt" %>
          </div>
          <div class='column is-2 pt-2 is-size-7'><strong>Gewicht</strong></div>
          <div class='column is-4'>
            <%= @character.weight && "#{@character.weight} Stein" %>
          </div>
        </div>
        <div class='columns mb-0'>
          <div class='column is-2 pt-2 is-size-7'><strong>Herkunft</strong></div>
          <div class='column is-4'><%= @character.origin %></div>
          <div class='column is-2 pt-2 is-size-7'><strong>Geboren</strong></div>
          <div class='column is-4'><%= @character.birthday %></div>
        </div>
        <div class='columns mb-0'>
          <div class='column is-2 pt-2 is-size-7'><strong>Spezies</strong></div>
          <div class='column is-4'><%= Species.name(@character.species_id) %></div>
          <div class='column is-2 pt-2 is-size-7'><strong>Alter</strong></div>
          <div class='column is-4'><%= @character.age %></div>
        </div>
        <div class='columns mb-0'>
          <div class='column is-2 pt-2 is-size-7'><strong>Kultur</strong></div>
          <div class='column is-4'><%= @character.culture %></div>
          <div class='column is-2 pt-2 is-size-7'><strong>Profession</strong></div>
          <div class='column is-4'><%= @character.profession %></div>
        </div>
      </div>
    </div>
    """

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
    <div class="card px-0 py-0">
      <header class="card-header">
        <button class='button is-white px-3 py-0 h-auto' type='submit'>
          <span class='icon has-text-link'>
            <i class='icon-ok'></i>
          </span>
        </button>
        <p class='card-header-title pl-0 py-0'>Persönliche Daten</p>
      </header>

      <div class="card-content px-1 py-2">
        <div class='columns mb-0'>

          <div class='column is-2'>
            <div class='field-label is-small'>
              <%= label f, :name, "Name", class: "label" %>
            </div>
          </div>
          <div class='column is-4'>
            <div class="field-body">
              <%= text_input f, :name, class: "input is-small" %>
              <%= error_tag f, :name %>
            </div>
          </div>
          <div class='column is-2'>
            <div class='field-label is-small'>
              <%= label f, :title, "Titel", class: "label" %>
            </div>
          </div>
          <div class='column is-4'>
            <div class="field-body">
              <%= text_input f, :title, class: "input is-small" %>
              <%= error_tag f, :title %>
            </div>
          </div>
        </div>

        <div class='columns mb-0'>
          <div class='column is-2'>
            <div class='field-label is-small'>
              <%= label f, :height, "Größe", class: "label" %>
            </div>
          </div>
          <div class='column is-4'>
            <div class="field-body">
              <%= text_input f, :height, class: "input is-small" %>
              <%= error_tag f, :height %>
            </div>
          </div>
          <div class='column is-2'>
            <div class='field-label is-small'>
              <%= label f, :weight, "Gewicht", class: "label" %>
            </div>
          </div>
          <div class='column is-4'>
            <div class="field-body">
              <%= text_input f, :weight, class: "input is-small" %>
              <%= error_tag f, :weight %>
            </div>
          </div>
        </div>

        <div class='columns mb-0'>
          <div class='column is-2'>
            <div class='field-label is-small'>
              <%= label f, :origin, "Herkunft", class: "label" %>
            </div>
          </div>
          <div class='column is-4'>
            <div class="field-body">
              <%= text_input f, :origin, class: "input is-small" %>
              <%= error_tag f, :origin %>
            </div>
          </div>
          <div class='column is-2'>
            <div class='field-label is-small'>
              <%= label f, :birthday, "Geboren", class: "label" %>
            </div>
          </div>
          <div class='column is-4'>
            <div class="field-body">
              <%= text_input f, :birthday, class: "input is-small" %>
              <%= error_tag f, :birthday %>
            </div>
          </div>
        </div>

        <div class='columns mb-0'>
          <div class='column is-2'>
            <div class='field-label is-small'>
              <%= label f, :species_id, "Spezies", class: "label" %>
            </div>
          </div>
          <div class='column is-4'>
            <div class='field-body'>
              <div class="select is-small">
                <%= select f, :species_id, @species_options, class: "is-flex" %>
                <%= error_tag f, :species_id %>
              </div>
            </div>
          </div>
          <div class='column is-2'>
            <div class='field-label is-small'>
              <%= label f, :age, "Alter", class: "label" %>
            </div>
          </div>
          <div class='column is-4'>
            <div class="field-body">
              <%= text_input f, :age, class: "input is-small" %>
              <%= error_tag f, :age %>
            </div>
          </div>
        </div>

        <div class='columns mb-0'>
          <div class='column is-2'>
            <div class='field-label is-small'>
              <%= label f, :culture, "Kultur", class: "label" %>
            </div>
          </div>
          <div class='column is-4'>
            <div class="field-body">
              <%= text_input f, :culture, class: "input is-small" %>
              <%= error_tag f, :culture %>
            </div>
          </div>
          <div class='column is-2'>
            <div class='field-label is-small'>
              <%= label f, :profession, "Profession", class: "label" %>
            </div>
          </div>
          <div class='column is-4'>
            <div class="field-body">
              <%= text_input f, :profession, class: "input is-small" %>
              <%= error_tag f, :profession %>
            </div>
          </div>
        </div>
      </div>
    </div>
    </form>
    """
  end
end
