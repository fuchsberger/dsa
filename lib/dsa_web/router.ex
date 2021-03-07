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

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    # user registration
    resources "/user", UserController, only: [:new, :create]
    get "/user/confirm/:token", UserController, :confirm

    # reset password logic
    get "/user/reset", UserController, :reset
    post "/user/reset", UserController, :send_reset_link
    get "/user/reset/:token", UserController, :reset_password
    put "/user/reset/:token", UserController, :update_password
  end

  # Private Routes
  scope "/", DsaWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/skills", SkillController, only: [:index]

    put "/character/:character_id/activate", CharacterController, :activate
    put "/character/:id/toggle_visible", CharacterController, :toggle_visible

    resources "/character", CharacterController do
      # get "skills", SkillController, :index
      resources "/skills", SkillController, only: [:index]
      get "/skills/edit", SkillController, :edit_skills

      put "/skills/update", SkillController, :update
      put "/skills/add", SkillController, :add_all
      delete "/skills/remove", SkillController, :remove_all

      # Roll Routes
      post "/roll/skill", RollController, :skill
      post "/roll/trait", RollController, :trait
    end

    resources "/user", UserController, only: [:delete, :edit, :update]

    live "/combat", DsaLive, :combat
    live "/roll", DsaLive, :roll

    live "/spells", DsaLive, :spells
  end

  # Admin Routes
  scope "/", DsaWeb do
    pipe_through [:browser, :authenticate_user, :admin]

    resources "/skills", SkillController, except: [:index, :show]
  end
end
