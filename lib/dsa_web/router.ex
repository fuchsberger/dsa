defmodule DsaWeb.Router do
  use DsaWeb, :router

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DsaWeb.Auth
    plug :put_root_layout, {DsaWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DsaWeb do
    pipe_through :browser

    # Private Routes
    get "/logout", SessionController, :delete
    live "/change_password", DsaLive, :change_password
    live "/character/new", DsaLive, :new_character
    live "/character", DsaLive, :character
    live "/dashboard", DsaLive, :dashboard
    live "/roll", DsaLive, :roll
    live "/skills", DsaLive, :skills

    # Public Routes
    live "/", DsaLive, :index
    live "/login", DsaLive, :login
    post "/login", SessionController, :create
    live "/confirm", DsaLive, :confirm
    live "/confirm/:token", DsaLive, :confirm
    live "/reset_password", DsaLive, :reset_password
    live "/reset_password/:token", DsaLive, :reset_password
    live "/register", DsaLive, :register
    live "/:path", DsaLive, :error404
  end
end
