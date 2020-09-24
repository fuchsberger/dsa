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

    get "/", SessionController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/:id", SessionController, :delete
  end

  scope "/", DsaWeb do
    pipe_through [:browser, :authenticate_user]

    get "/characters/new", PageController, :create_character

    get "/change_password", UserController, :edit_password
    put "/change_password", UserController, :change_password

    live "/characters", ManageLive, :characters
    live "/character/:character_id", CharacterLive, :edit

    live "/group/:id/combat", GroupLive, :combat
    live "/group/:id/roll", GroupLive, :roll
  end

  scope "/", DsaWeb do
    pipe_through [:browser, :authenticate_user, :admin]

    live "/groups", ManageLive, :groups
    live "/users", ManageLive, :users
  end
end
