defmodule DsaWeb.AccountComponent do

  use DsaWeb, :live_component

  alias Dsa.{Accounts, Email, Mailer}

  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset, Routes.session_path(@socket, :create),
      phx_change: :change,
      phx_submit: :submit,
      phx_target: @myself,
      phx_trigger_action: @trigger_login?,
      novalidate: true
    %>
      <%= icon @socket, "tailwind", "mt-4 text-indigo-600 h-12 w-auto mx-auto" %>

      <%# Heading %>
      <%= case @action do %>
        <% _ -> %>
          <h2 class="main">Willkommen in Aventurien!</h2>
      <% end %>

      <%# Link %>
      <%= case @action do %>
        <% :confirm -> %>
          <p class="my-4 text-center text-gray-600">Erfolgreich registriert!<br/>Dein Account muss noch aktiviert werden.<br/>Bitte überprüfe Deinen Email Eingang.</p>

        <% :login -> %>
          <p class="my-4 text-center text-gray-600">Noch nicht <%= live_patch "registriert", to: Routes.dsa_path(@socket, :register) %> ?</p>

        <% :register -> %>
          <p class="my-4 text-center text-gray-600">Bereits registriert? <%= live_patch "Login", to: Routes.dsa_path(@socket, :login) %></p>

        <% _ -> %>
      <% end %>

      <input type="hidden" name="remember" value="true">

      <div class='relative bg-white rounded-md <%= if @action != :register, do: "hidden" %>'>
        <div class="input-icon-wrapper">
          <svg class='w-5 h-5' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
          </svg>
        </div>
        <%= text_input f, :username,
          autocomplete: "username",
          class: "normal icon relative border #{if false, do: "error" }",
          placeholder: "Benutzername"
        %>
      </div>
      <%= if @action == :register, do: error_tag f, :username %>

      <div class='relative bg-white rounded-md <%= unless @action == :register, do: "hidden" %> mt-3'>
        <div class="input-icon-wrapper">
          <svg class='w-5 h-5' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
          </svg>
        </div>
        <%= email_input f, :email,
          autocomplete: "email",
          class: "normal icon",
          placeholder: "Email Addresse"
        %>
      </div>
      <%= if @action == :register, do: error_tag f, :email %>

      <div class='relative bg-white rounded-md <%= unless @action == :register, do: "hidden" %> mt-3'>
        <div class="input-icon-wrapper">
          <svg class='w-5 h-5' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
          </svg>
        </div>
        <%= password_input f, :new_password,
          autocomplete: "new-password",
          class: "normal icon",
          placeholder: "Passwort",
          value: input_value(f, :new_password)
        %>
      </div>
      <%= if @action == :register, do: error_tag f, :new_password %>

      <div class='relative bg-white rounded-md <%= unless @action == :register, do: "hidden" %> mt-3'>
        <div class="input-icon-wrapper">
          <svg class='w-5 h-5' fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
          </svg>
        </div>
        <%= password_input f, :password_confirm,
          autocomplete: "new-password",
          class: "normal icon",
          placeholder: "Passwort wiederholen",
          value: input_value(f, :password_confirm)
        %>
      </div>
      <%= if @action == :register, do: error_tag f, :password_confirm %>

      <div class="hidden flex items-center justify-between">
        <div class="flex items-center">
          <input id="remember_me" disabled name="remember_me" type="checkbox" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded">
          <label for="remember_me" class="ml-2 block text-sm text-gray-900">
            eingeloggt bleiben
          </label>
        </div>

        <%= live_patch "Passwort vergessen?", to: Routes.dsa_path(@socket, :reset_password), class: "font-medium text-indigo-600 hover:text-indigo-500 text-sm" %>
      </div>

      <button type="submit" class="large group relative mx-auto block pl-10 pr-4 mt-3">
        <%= icon @socket, "lock-closed", "absolute block left-2 top-2 w-6 h-6 text-indigo-500 group-hover:text-indigo-400" %>
        <%= case @action do %>
          <% :confirm -> %><span>Erneut senden</span>
          <% :register -> %><span>Registrieren</span>
          <% _ -> %><span>Update</span>
        <% end %>
      </button>
    </form>
    """
  end

  def mount(socket) do
    {:ok, socket
    |> assign(:error, false)
    |> assign(:changeset, Accounts.change_session())
    |> assign(:confirmation_sent?, false)
    |> assign(:trigger_login?, false)}
  end

  def update(assigns, socket) do
    changeset =
      case assigns.action do
        :register -> Accounts.change_registration(%Accounts.User{}, %{})
        _ -> nil
      end

    {:ok, socket
    |> assign(:action, assigns.action)
    |> assign(:email, assigns.email)}
  end

  def handle_event("change", %{"user" => params}, socket) do
    changeset =
      case socket.assigns.action do
        :register -> Accounts.change_registration(%Accounts.User{}, params)
        _ -> nil
      end

    {:noreply, socket
    |> assign(:changeset, changeset)}
  end

  def handle_event("submit", %{"user" => params}, socket) do
    case socket.assigns.action do
      :confirm ->
        email = Map.get(params, "email")
        email = if email == "", do: socket.assigns.email, else: email

        # Send confirmation email again.
        Accounts.get_user_by(email: email)
        |> Email.confirmation_email()
        |> Mailer.deliver_now()

        {:noreply, socket}

      :register ->
        # first see if user already exists
        case Accounts.get_user_by(email: Map.get(params, "email")) do
          # User does not exist yet --> create
          nil ->
            case Accounts.register_user(params) do
              {:ok, user} ->
                # Send confirmation email.
                user
                |> Email.confirmation_email()
                |> Mailer.deliver_now()

                {:noreply, assign(socket, :action, :confirm)}

              {:error, changeset} ->
                {:noreply, assign(socket, :changeset, changeset)}
            end

          user ->
            {:noreply, socket
            |> put_flash(:error, "Ein Account mit der Email Addresse #{user.email} existiert bereits.")
            |> push_patch(to: Routes.dsa_path(socket, :login))}
        end
    end
  end
end
