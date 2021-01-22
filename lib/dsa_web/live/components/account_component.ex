defmodule DsaWeb.AccountComponent do

  use DsaWeb, :live_component

  def render(assigns) do
    ~L"""
    <%# Tailwind CSS Logo %>
    <svg class='text-indigo-600 h-12 w-auto mx-auto' fill="currentColor" viewBox="0 0 35 32">
      <path d="M15.258 26.865a4.043 4.043 0 01-1.133 2.917A4.006 4.006 0 0111.253 31a3.992 3.992 0 01-2.872-1.218 4.028 4.028 0 01-1.133-2.917c.009-.698.2-1.382.557-1.981.356-.6.863-1.094 1.47-1.433-.024.109.09-.055 0 0l1.86-1.652a8.495 8.495 0 002.304-5.793c0-2.926-1.711-5.901-4.17-7.457.094.055-.036-.094 0 0A3.952 3.952 0 017.8 7.116a3.975 3.975 0 01-.557-1.98 4.042 4.042 0 011.133-2.918A4.006 4.006 0 0111.247 1a3.99 3.99 0 012.872 1.218 4.025 4.025 0 011.133 2.917 8.521 8.521 0 002.347 5.832l.817.8c.326.285.668.551 1.024.798.621.33 1.142.826 1.504 1.431a3.902 3.902 0 01-1.504 5.442c.033-.067-.063.036 0 0a8.968 8.968 0 00-3.024 3.183 9.016 9.016 0 00-1.158 4.244zM19.741 5.123c0 .796.235 1.575.676 2.237a4.01 4.01 0 001.798 1.482 3.99 3.99 0 004.366-.873 4.042 4.042 0 00.869-4.386 4.02 4.02 0 00-1.476-1.806 3.994 3.994 0 00-5.058.501 4.038 4.038 0 00-1.175 2.845zM23.748 22.84c-.792 0-1.567.236-2.226.678a4.021 4.021 0 00-1.476 1.806 4.042 4.042 0 00.869 4.387 3.99 3.99 0 004.366.873A4.01 4.01 0 0027.08 29.1a4.039 4.039 0 00-.5-5.082 4 4 0 00-2.832-1.18zM34 15.994c0-.796-.235-1.574-.675-2.236a4.01 4.01 0 00-1.798-1.483 3.99 3.99 0 00-4.367.873 4.042 4.042 0 00-.869 4.387 4.02 4.02 0 001.476 1.806 3.993 3.993 0 002.226.678 4.003 4.003 0 002.832-1.18A4.04 4.04 0 0034 15.993z"/>
      <path d="M5.007 11.969c-.793 0-1.567.236-2.226.678a4.021 4.021 0 00-1.476 1.807 4.042 4.042 0 00.869 4.386 4.001 4.001 0 004.366.873 4.011 4.011 0 001.798-1.483 4.038 4.038 0 00-.5-5.08 4.004 4.004 0 00-2.831-1.181z"/>
    </svg>

    <%# Heading %>
    <%= case @action do %>
      <% _ -> %>
        <h2 class="main">Willkommen in Aventurien!</h2>
    <% end %>

    <%# Link %>
    <%= case @action do %>
      <% :login -> %>
        <p class="mt-2 text-center text-gray-600">Noch nicht <%= live_patch "registriert", to: Routes.dsa_path(@socket, :register) %> ?</p>

      <% :register -> %>
        <p class="mt-2 text-center text-gray-600">Bereits registriert? <%= live_patch "Login", to: Routes.dsa_path(@socket, :login) %></p>

      <% _ -> %>
    <% end %>



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

        <button type="submit" class="large group relative mx-auto block pl-10 pr-4">
          <!-- Heroicon name: lock-closed -->
          <svg class="absolute block left-2 top-2 h-6 w-6 text-indigo-500 group-hover:text-indigo-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" />
          </svg>
          <%= case @action do %>
            <% :register -> %><span>Registrieren</span>
            <% _ -> %><span>Update</span>
          <% end %>
        </button>
      </div>
    </form>

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
