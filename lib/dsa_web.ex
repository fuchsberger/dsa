defmodule DsaWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use DsaWeb, :controller
      use DsaWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: DsaWeb

      import Plug.Conn
      import Phoenix.LiveView.Controller
      import DsaWeb.Gettext

      alias DsaWeb.Router.Helpers, as: Routes

      require Logger
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent
      use Phoenix.HTML

      import Phoenix.HTML.Form, except: [
        email_input: 3,
        number_input: 3,
        password_input: 3,
        text_input: 3,
        select: 4
      ]

      import Phoenix.LiveView.Helpers
      import DsaWeb.DsaHelpers
      import DsaWeb.CharacterHelpers
      import DsaWeb.FormHelpers
      import DsaWeb.ViewHelpers

      import DsaWeb.DsaLive, only: [broadcast: 1]
      import DsaWeb.Gettext

      alias DsaWeb.Router.Helpers, as: Routes

      require Logger
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/dsa_web/templates", namespace: DsaWeb
      use Phoenix.HTML

      import Phoenix.HTML.Form, except: [
        email_input: 3,
        number_input: 3,
        password_input: 3,
        text_input: 3,
        select: 4
      ]

      import DsaWeb.Gettext

      import DsaWeb.FormHelpers
      import DsaWeb.DsaHelpers
      import DsaWeb.CharacterHelpers
      import DsaWeb.ViewHelpers
      import Phoenix.LiveView.Helpers

      alias DsaWeb.Router.Helpers, as: Routes
      alias DsaWeb.LogView
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Phoenix.LiveView.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
