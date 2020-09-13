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

    live "/spells", ManageLive, :spells
    live "/prayers", ManageLive, :prayers
    live "/traditions", ManageLive, :traditions
  end

  scope "/", DsaWeb do
    pipe_through [:browser, :authenticate_user]

    get "/characters/new", PageController, :create_character

    live "/characters", CharacterLive, :index
    live "/characters/:character_id", CharacterLive, :edit

    live "/group/:id", GroupLive, :index
    live "/group/:id/combat", GroupLive, :combat
    live "/group/:id/roll", GroupLive, :roll

    live "/manage/armors", ManageLive, :armors

    live "/manage/combat_skills", ManageLive, :combat_skills
    live "/manage/traits", ManageLive, :traits
    live "/manage/skills", ManageLive, :skills
    live "/manage/groups", ManageLive, :groups
    live "/manage/users", ManageLive, :users
    live "/manage/mweapons", ManageLive, :mweapons
    live "/manage/fweapons", ManageLive, :fweapons
  end
end
