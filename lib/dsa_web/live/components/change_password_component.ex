defmodule DsaWeb.ChangePasswordComponent do

  use DsaWeb, :live_component

  alias Dsa.Accounts

  def render(assigns) do
    ~L"""
    <div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <img class="mx-auto h-12 w-auto" src="https://tailwindui.com/img/logos/workflow-mark-indigo-600.svg" alt="Workflow">
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          Account Verwaltung
        </h2>

      </div>

      <%= f = form_for @changeset, Routes.session_path(@socket, :create),
        phx_change: :change,
        phx_submit: :submit,
        phx_target: @myself,
        novalidate: true
      %>

        <%= label f, :password_old, "Altes Passwort", class: "block text-center text-gray-600 mb-2" %>
        <%= password_input f, :password_old,
          autocomplete: "current-password",
          class: "appearance-none rounded-none relative block w-full px-3 py-2 border #{if true, do: "border-red-800", else: "border-gray-300" } placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm",
          placeholder: "Altes Passwort"
        %>
        <%= error_tag f, :password_old %>

        <%= label f, :password, "Neues Passwort", class: "block text-center text-gray-600 mt-3 mb-2" %>

        <div class="rounded-md shadow-sm -space-y-px">
          <%= password_input f, :password,
            autocomplete: "current-password",
            class: "appearance-none rounded-none relative block w-full px-3 py-2 border #{if false, do: "border-red-800", else: "border-gray-300" } placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm",
            placeholder: "Neues Passwort",
            value: input_value(f, :password)
          %>
          <%= password_input f, :password_confirm,
            autocomplete: "current-password",
            class: "appearance-none rounded-none relative block w-full px-3 py-2 border #{if false, do: "border-red-800", else: "border-gray-300" } placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm",
            placeholder: "Neues Passwort wiederholen",
            value: input_value(f, :password_confirm)
          %>
        </div>


        <button type="submit" class="group relative w-full flex justify-center my-4 py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
          <span class="absolute left-0 inset-y-0 flex items-center pl-3">
            <!-- Heroicon name: lock-closed -->
            <svg class="h-5 w-5 text-indigo-500 group-hover:text-indigo-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
            </svg>
          </span>
          Passwort ändern
        </button>

      </form>
    </div>
  </div>
  """
  end

  # def preload(list_of_assigns), do: list_of_assigns

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{user: user}, socket) do
    {:ok, assign(socket, :changeset, Accounts.change_password(user))}
  end

  def handle_event("change", %{"user" => params}, socket) do
    user = socket.assigns.changeset.data
    changeset = Accounts.change_password(user, params)
    Logger.warn(inspect(changeset.errors))

    {:noreply, assign(socket, :changeset, Accounts.change_password(user, params))}
  end

  def handle_event("submit", _params, socket) do
    {:noreply, assign(socket, :trigger_submit?, true)}
  end
end
