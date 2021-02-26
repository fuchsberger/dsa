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
    plug :put_root_layout, {DsaWeb.LayoutView, :root}
    plug DsaWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public Routes
  scope "/", DsaWeb do
    pipe_through :browser

    resources "/", PageController, only: [:index]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/user", UserController, only: [:new, :create]
    get "/user/confirm/:token", UserController, :confirm

    live "/confirm", DsaLive, :confirm
    live "/confirm/:token", DsaLive, :confirm
    live "/reset_password", DsaLive, :reset_password
    live "/reset_password/:token", DsaLive, :reset_password
  end

  # Private Routes
  scope "/", DsaWeb do
    pipe_through [:browser, :authenticate_user]

    live "/character/new", DsaLive, :new_character
    live "/character", DsaLive, :character
    live "/combat", DsaLive, :combat
    live "/dashboard", DsaLive, :dashboard
    live "/roll", DsaLive, :roll
    live "/skills", DsaLive, :skills
    live "/spells", DsaLive, :spells
  end
end
