defmodule DsaWeb.Router do
  use DsaWeb, :router

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

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", DsaWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/characters", CharacterController, only: [:index, :delete]

    live "/characters/new", CharacterLive, :new
    live "/characters/:character_id", CharacterLive, :edit
    live "/group/:group_id", GroupLive
  end
end
