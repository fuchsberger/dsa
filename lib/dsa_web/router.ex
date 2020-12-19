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

    live "/", DsaLive, :index
    post "/", SessionController, :create
    delete "/:id", SessionController, :delete

    live "/login", DsaLive, :login
  end

  # scope "/", DsaWeb do
  #   pipe_through [:browser, :authenticate_user]

  #   get "/characters/new", PageController, :create_character

  #   get "/change_password", UserController, :edit_password
  #   put "/change_password", UserController, :change_password

  #   live "/characters", ManageLive, :characters


    # live "/character/:character_id/combat", CharacterLive, :combat
    # live "/character/:character_id/gear", CharacterLive, :gear
    # live "/character/:character_id/skills", CharacterLive, :skills
    # live "/character/:character_id/magic", CharacterLive, :magic
    # live "/character/:character_id/wonders", CharacterLive, :wonders
    # live "/character/:character_id", CharacterLive, :index


    # live "/group/:id/combat", GroupLive, :combat
    # live "/group/:id/roll", GroupLive, :roll
  # end

  # scope "/", DsaWeb do
  #   pipe_through [:browser, :authenticate_user, :admin]

  #   live "/groups", ManageLive, :groups
  #   live "/users", ManageLive, :users
  # end
end
