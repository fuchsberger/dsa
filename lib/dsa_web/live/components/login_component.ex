defmodule DsaWeb.LoginComponent do

  use DsaWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <img class="mx-auto h-12 w-auto" src="https://tailwindui.com/img/logos/workflow-mark-indigo-600.svg" alt="Workflow">
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          Willkommen in Aventurien!
        </h2>
        <p class="mt-2 text-center text-sm text-gray-600">
          Noch nicht
          <%= live_patch "registriert", to: Routes.dsa_path(@socket, :register), class: "font-medium text-indigo-600 hover:text-indigo-500" %>
          ?
        </p>
      </div>

      <%= f = form_for @session_changeset, Routes.session_path(@socket, :create),
        as: :session,
        class: "mt-8 space-y-6",
        phx_change: :change,
        phx_submit: :login,
        phx_target: @myself,
        phx_trigger_action: @trigger_submit_login?
      %>
        <input type="hidden" name="remember" value="true">

        <div class="rounded-md shadow-sm -space-y-px">
          <div>
            <%= label f, :email, "Email address", class: "sr-only" %>
            <%= email_input f, :email,
              autocomplete: "email",
              class: "appearance-none rounded-none relative block w-full px-3 py-2 border #{if @error, do: "border-red-800", else: "border-gray-300" } placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm",
              placeholder: "Email Addresse"
            %>
          </div>
          <div>
            <%= label f, :password, "Passwort", class: "sr-only" %>
            <%= password_input f, :password,
              autocomplete: "current-password",
              class: "appearance-none rounded-none relative block w-full px-3 py-2 border #{if @error, do: "border-red-800", else: "border-gray-300" } placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm",
              placeholder: "Passwort",
              value: input_value(f, :password)
            %>
          </div>
        </div>

        <div class="flex items-center justify-between">
          <div class="flex items-center">
            <input id="remember_me" disabled name="remember_me" type="checkbox" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded">
            <label for="remember_me" class="ml-2 block text-sm text-gray-900">
              eingeloggt bleiben
            </label>
          </div>

          <%= live_patch "Passwort vergessen?", to: Routes.dsa_path(@socket, :reset_password), class: "font-medium text-indigo-600 hover:text-indigo-500 text-sm" %>
        </div>

        <div>
          <button type="submit" class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            <span class="absolute left-0 inset-y-0 flex items-center pl-3">
              <%= icon "lock-closed", "inline-block h-5 w-5 text-indigo-500 group-hover:text-indigo-400" %>
            </span>
            Einloggen
          </button>
        </div>
      </form>
    </div>
  </div>
  """
  end

  def mount(socket) do
    {:ok, socket
    |> assign(:error, false)
    |> assign(:session_changeset, Dsa.Accounts.change_session())
    |> assign(:trigger_submit_login?, false)}
  end

  def handle_event("change", %{"session" => params}, socket) do
    {:noreply, socket
    |> assign(:session_changeset, Dsa.Accounts.change_session(params))
    |> assign(:invalid_login?, false)}
  end

  def handle_event("login", _params, socket) do
    {:noreply, assign(socket, :trigger_submit_login?, true)}
  end
end
