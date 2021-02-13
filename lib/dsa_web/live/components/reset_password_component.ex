defmodule DsaWeb.ResetPasswordComponent do

  use DsaWeb, :live_component

  alias Dsa.{Accounts, Email, Mailer}

  def render(assigns) do
    ~L"""
    <div class="max-w-md mx-auto md:pt-4">
      <%= icon(:tailwind, class: "h-12 mx-auto text-indigo-600") %>
      <h2 class="mt-4 text-center text-3xl font-extrabold text-gray-900">Account Verwaltung</h2>

      <%= cond do %>
        <% is_nil(@changeset) -> %>
          <p class='text-center text-gray-600 my-3'>Der Link ist abgelaufen oder ungültig.</p>

        <% is_nil(@user_id) && is_nil(@token) -> %>
          <%= f = form_for @changeset, "#",
            class: @submitted? && "hidden",
            phx_change: :change_email,
            phx_submit: :submit_email,
            phx_target: @myself,
            novalidate: true
          %>
            <%= label f, :email, "Um dein Passwort zurückzusetzen benötigen wir die Email Adresse mit der du dich registriert hast.", class: "block text-center text-gray-600 my-3" %>

            <%= email_input f, :email,
              autocomplete: "email",
              class: "w-full px-3 py-2 rounded-md sm:text-sm",
              placeholder: "Email Adresse"
            %>
            <%= error_tag f, :email %>

            <%= submit class: "group relative w-full flex justify-center my-4 py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500", disabled: not @changeset.valid? do %>
              <span class="absolute left-0 inset-y-0 flex items-center pl-3">
                <!-- Heroicon name: lock-closed -->
                <svg class="h-5 w-5 text-indigo-500 group-hover:text-indigo-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                </svg>
              </span>
              Sende Passwort Reset Link
            <% end %>
          </form>

          <p class='text-center text-gray-600 my-3 <%= unless @submitted?, do: "hidden" %>'>Ein Link zum Zurücksetzen deines Passworts wurde an die angegebene Email Adresse gesendet.</p>

        <% true -> %>
          <%= f = form_for @changeset, "#",
            phx_change: :change_password,
            phx_submit: :submit_password,
            phx_target: @myself,
            novalidate: true
          %>
            <%= if @user_id do %>
              <%= label f, :password_old, "Altes Passwort", class: "block text-center text-gray-600 mb-2" %>

              <%= password_input f, :password_old,
                autocomplete: "current-password",
                class: "w-full px-3 py-2 rounded-md sm:text-sm",
                placeholder: "Altes Passwort",
                value: input_value(f, :password_old)
              %>
              <%= error_tag f, :password_old %>
            <% end %>

            <%= label f, :password, "Neues Passwort", class: "block text-center text-gray-600 mt-3 mb-2" %>

            <div class="rounded-md shadow-sm -space-y-px">
              <%= password_input f, :password,
                autocomplete: "new-password",
                class: "w-full px-3 py-2 border rounded-t-md sm:text-sm",
                placeholder: "Neues Passwort",
                value: input_value(f, :password)
              %>
              <%= password_input f, :password_confirm,
                autocomplete: "new-password",
                class: "w-full px-3 py-2 rounded-b-md sm:text-sm",
                placeholder: "Neues Passwort wiederholen",
                value: input_value(f, :password_confirm)
              %>
            </div>
            <%= error_tag f, :password %>
            <%= error_tag f, :password_confirm %>


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
      <% end %>

      <div class='text-center text-sm'>
        Hier gehts zurück zum
        <%= live_patch "Login", to: Routes.dsa_path(@socket, :login), class: "font-medium text-indigo-600 hover:text-indigo-500" %>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, :submitted?, false)}
  end

  def update(%{token: token, user_id: user_id}, socket) do


    changeset =
      case {token, user_id} do
        # show email form
        {nil, nil} -> Accounts.change_email(%{})

        # show password form with old password prompt
        {nil, user_id} -> Accounts.change_password(Accounts.get_user(user_id), %{}, false)

        # show password form without password prompt
        {token, nil} ->
          case Accounts.get_user_by(reset: true, token: token) do
            nil -> nil
            user -> Accounts.change_password(user, %{}, true)
          end

        {token, user_id} -> nil # hack attempt, redirect to index
      end

      {:ok, socket
      |> assign(:bypass_security?, is_nil(user_id) && not is_nil(token))
      |> assign(:changeset, changeset)
      |> assign(:token, token)
      |> assign(:user_id, user_id)}
  end

  def handle_event("change_email", %{"user" => params}, socket) do
    {:noreply, assign(socket, :changeset, Accounts.change_email(params))}
  end

  def handle_event("submit_email", %{"user" => params}, socket) do
    case Accounts.get_user_by(email: params["email"]) do
      nil ->
        Pbkdf2.no_user_verify()

        {:noreply, socket
        |> put_flash(:error, "Die angegebene Email Addresse existiert nicht.")
        |> push_patch(to: Routes.dsa_path(socket, :reset_password))}

      user ->
        case Accounts.reset_user(user) do
          {:ok, user} ->
            user
            |> Email.reset_email()
            |> Mailer.deliver_now()

            {:noreply, assign(socket, :submitted?, true)}

          {:error, changeset} ->
            Logger.warn("Error preparing user for reset: \n#{inspect(changeset)}")
            {:noreply, socket}
        end
    end
  end

  def handle_event("change_password", %{"user" => params}, socket) do
    user = socket.assigns.changeset.data
    bypass? = socket.assigns.bypass_security?
    {:noreply, assign(socket, :changeset, Accounts.change_password(user, params, bypass?))}
  end

  def handle_event("submit_password", %{"user" => params}, socket) do
    user = socket.assigns.changeset.data
    bypass? = socket.assigns.bypass_security?

    case Accounts.update_password(user, params, bypass?) do
      {:ok, user} ->
        {:noreply, socket
        |> put_flash(:info, "Passwort erfolgreich geändert!")
        |> push_patch(to: Routes.dsa_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
