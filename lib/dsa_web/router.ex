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
    resources "/characters", CharacterController, except: [:show]
    post "/characters/add_skill", CharacterController, :add_skill
    delete "characters/remove_skill/:character_id/:skill_id", CharacterController, :remove_skill
    live "/group/:id", GroupLive
    live "/manage/skills", ManageLive, :skills
    live "/manage/groups", ManageLive, :groups
    live "/manage/users", ManageLive, :users
  end
end
