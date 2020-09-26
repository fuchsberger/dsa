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
    end
  end

  def live_component do
    quote do
      use Phoenix.HTML
      use Phoenix.LiveComponent

      import Phoenix.HTML.Form, except: [number_input: 2, number_input: 3, range_input: 3, select: 3, select: 4, text_input: 2, text_input: 3, password_input: 2, password_input: 3]
      import DsaWeb.FormHelpers

      require Logger
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView

      import DsaWeb.LiveHelpers

      require Logger
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/dsa_web/templates", pattern: "**/*", namespace: DsaWeb

      # Import convenience functions from controllers

      import Phoenix.LiveView.Helpers
      import Ecto.Changeset, only: [get_field: 2, get_field: 3]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
      import DsaWeb.Auth, only: [authenticate_user: 2, admin: 2]
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import DsaWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View
      import Phoenix.HTML.Form, except: [number_input: 2, number_input: 3, range_input: 3, select: 3, select: 4, text_input: 2, text_input: 3, password_input: 2, password_input: 3]
      import Dsa.Lists
      import DsaWeb.DsaHelpers
      import DsaWeb.FormHelpers
      import DsaWeb.Gettext
      alias DsaWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
