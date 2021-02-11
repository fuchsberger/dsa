defmodule DsaWeb.ResetPasswordComponent do

  use DsaWeb, :live_component

  alias Dsa.{Accounts, Email, Mailer}

  def render(assigns) do
    ~L"""
    <div class="max-w-md mx-auto md:pt-4">
      <%= icon(:tailwind, class: "h-12 mx-auto text-indigo-600") %>
      <h2 class="mt-4 text-center text-3xl font-extrabold text-gray-900">Account Verwaltung</h2>

      <%= f = form_for @changeset, "#",
        phx_change: :change,
        phx_submit: :submit,
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

      <div class='text-center text-sm'>
        Hier gehts zurück zum
        <%= live_patch "Login", to: Routes.dsa_path(@socket, :login), class: "font-medium text-indigo-600 hover:text-indigo-500" %>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket
    |> assign(:changeset, Accounts.change_email(%{}))
    |> assign(:submitted?, false)}
  end

  def handle_event("change", %{"user" => params}, socket) do
    {:noreply, assign(socket, :changeset, Accounts.change_email(params))}
  end

  def handle_event("submit", %{"user" => params}, socket) do
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
end
