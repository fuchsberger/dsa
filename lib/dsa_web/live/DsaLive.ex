defmodule DsaWeb.DsaLive do
  use Phoenix.LiveView, layout: {DsaWeb.LayoutView, "live.html"}

  alias Dsa.Accounts
  alias DsaWeb.Router.Helpers, as: Routes

  require Logger

  @group_id 1

  def topic, do: "log:#{@group_id}"

  def render(assigns) do
    ~L"""
    <%= case @live_action do %>
      <% :change_password -> %>
        <%= live_component @socket, DsaWeb.ChangePasswordComponent, id: :change_password, user: @user %>

      <% :login -> %>
        <%= live_component @socket, DsaWeb.LoginComponent, id: :login %>

      <% :dashboard -> %>
        <%= live_component @socket, DsaWeb.DashboardComponent, id: :dashboard, user: @user %>

      <% :new_character -> %>
        <%= live_component @socket, DsaWeb.CharacterComponent,
          id: :character,
          action: :create,
          character: %Dsa.Accounts.Character{},
          user_id: @user.id
        %>

      <% :character -> %>
        <%= live_component @socket, DsaWeb.CharacterComponent,
          id: :character,
          action: :update,
          character: @user.active_character,
          user_id: @user.id
        %>

      <% :roll -> %>
        <%= live_component @socket, DsaWeb.RollComponent, id: :roll, character_id: @user.active_character_id %>

      <% :reset_password -> %>
        <%= live_component @socket, DsaWeb.ResetPasswordComponent, id: :reset_password %>

      <% :skills -> %>
        <%= live_component @socket, DsaWeb.SkillComponent, id: :skills, character_id: @user.active_character_id %>

      <% :error404 -> %>
        <%= live_component @socket, DsaWeb.ErrorComponent, type: 404 %>

      <% _ -> %>
        <%= live_component @socket, DsaWeb.AccountComponent, id: :account,
          action: @live_action,
          email: @email
        %>
    <% end %>
    """
  end

  def mount(params, session, socket) do
    user_id = Map.get(session, "user_id")
    user = user_id && Accounts.get_user!(user_id)

    Logger.warn Dsa.Data.Skill.options()

    # Add error message from param if it exists
    error = Map.get(params, "error")
    socket = if is_nil(error), do: socket, else: put_flash(socket, :error, error)

    DsaWeb.Endpoint.subscribe(topic())

    {:ok, socket
    |> assign(:email, Map.get(params, "email"))
    |> assign(:show_log?, false)
    |> assign(:user, user)}
  end

  def handle_info({:log, entry}, socket) do
    send_update(DsaWeb.LogComponent, id: :log, action: :add, entry: entry)
    {:noreply, assign(socket, :log_open?, true)}
  end

  def handle_info(:clear_logs, socket) do
    send_update(DsaWeb.LogComponent, id: :log, action: :clear)
    {:noreply, socket}
  end

  def handle_info(:update_user, socket) do
    {:noreply, assign(socket, :user, Accounts.get_user!(socket.assigns.user.id))}
  end

  def handle_info({:update_user, user}, socket), do: {:noreply, assign(socket, :user, user)}

  def handle_info({:update_character, character}, socket) do
    {:noreply, assign(socket, :user, Map.put(socket.assigns.user, :active_character, character))}
  end

  def handle_info(unknown, socket) do
    {:noreply, socket}
  end

  def handle_params(params, _uri, socket) do

    %{live_action: action, user: user} = socket.assigns
    token = Map.get(params, "token")

    cond do
      # index is a simple redirect to dashboard or login
      action == :index ->
        target = if is_nil(user), do: :login, else: :dashboard
        {:noreply, push_patch(socket, to: Routes.dsa_path(socket, target), replace: true)}

      # attempt to confirm users
      action == :confirm && not is_nil(token) ->
        # if user exists and is not yet confirmed, confirm her and redirect to login.
        case Accounts.get_user_by(confirmed: false, token: token) do
          nil ->
            {:noreply, socket
            |> put_flash(:error, "Benutzer existiert nicht oder wurde bereits aktiviert.")
            |> push_patch(to: Routes.dsa_path(socket, :login))}

          user ->
            case Accounts.update_user(user, %{confirmed: true, token: nil}) do
              {:ok, user} ->
                {:noreply, socket
                |> put_flash(:info, "Aktivierung abgeschlossen. Du kannst dich jetzt einloggen.")
                |> push_patch(to: Routes.dsa_path(socket, :login))}

              {:error, changeset} ->
                Logger.warn(inspect(changeset.errors))
                {:noreply, socket
                |> put_flash(:error, "Ein unerwarteter Fehler ist aufgetreten.")
                |> push_patch(to: Routes.dsa_path(socket, :login))}
            end
        end

      # Do not allow unauthenticated users to access restricted pages
      is_nil(user) && Enum.member?([:dashboard, :character, :skills, :roll, :reset_password], action) ->
        {:noreply, socket
        |> put_flash(:error, "Die angeforderte Seite benötigt Authentifizierung.")
        |> push_patch(to: Routes.dsa_path(socket, :login))}

      # redirect to dashboard if user does not has an active character and page requires it
      not is_nil(user) && is_nil(user.active_character_id) && Enum.member?([:roll, :skills, :character], action) ->
        {:noreply, push_patch(socket, to: Routes.dsa_path(socket, :dashboard), replace: true)}

      # all went normal, proceed
      true ->
        # handle page title
        socket =
          case socket.assigns.live_action do
            :change_password -> assign(socket, :page_title, "Account")
            :confirm -> assign(socket, :page_title, "Registrierung")
            :login -> assign(socket, :page_title, "Login")
            :new_character -> assign(socket, :page_title, "Heldenerschaffung")
            :character -> assign(socket, :page_title, "Held")
            :dashboard -> assign(socket, :page_title, "Übersicht")
            :register -> assign(socket, :page_title, "Registrierung")
            :roll -> assign(socket, :page_title, "Probe")
            :skills -> assign(socket, :page_title, "Talente")
            _ -> assign(socket, :page_title, "404 Error")
          end

        {:noreply, socket
        |> assign(:log_open?, false)
        |> assign(:account_dropdown_open?, false)
        |> assign(:menu_open?, false)}
    end
  end

  def handle_event("close-account-dropdown", %{"key" => "Esc"}, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, false)}
  end

  def handle_event("close-account-dropdown", %{"key" => "Escape"}, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, false)}
  end

  def handle_event("close-account-dropdown", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("toggle-account-dropdown", _params, socket) do
    {:noreply, assign(socket, :account_dropdown_open?, !socket.assigns.account_dropdown_open?)}
  end

  def handle_event("toggle-log", _params, socket) do
    {:noreply, assign(socket, :log_open?, !socket.assigns.log_open?)}
  end

  def handle_event("toggle-menu", _params, socket) do
    {:noreply, assign(socket, :menu_open?, !socket.assigns.menu_open?)}
  end

  defp gravatar_url(user, size \\ 24)

  defp gravatar_url(nil, size), do: "https://s.gravatar.com/avatar/invalid?s=#{size}"

  defp gravatar_url(user, size) do
    "https://s.gravatar.com/avatar/#{Base.encode16(:erlang.md5(user.email), case: :lower)}?s=#{size}"
  end
end
