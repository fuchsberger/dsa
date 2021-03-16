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

    # Authentication
    resources "/", SessionController, only: [:index]
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout/:user_id", SessionController, :delete

    resources "/character", CharacterController, only: [:show]
    resources "/groups", GroupController, only: [:index]

    # Public Data Routes
    resources "/skills", SkillController, only: [:index]

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
    resources "/spells", SpellController, only: [:index]

    put "/character/:id/activate", CharacterController, :activate
    put "/character/:id/toggle_visible", CharacterController, :toggle_visible

    resources "/characters", CharacterController, except: [:show] do

      # Character Skills
      resources "/skills", CharacterSkillController, only: [:index], as: :skill
      get "/skills/edit", CharacterSkillController, :edit_all, as: :skill
      put "/skills/update", CharacterSkillController, :update_all, as: :skill
      put "/skills/add", CharacterSkillController, :add_all, as: :skill
      delete "/skills/remove", CharacterSkillController, :remove_all, as: :skill

      # Character Spells
      resources "/spells", CharacterSpellController, only: [:index], as: :spell
      get "/spells/edit", CharacterSpellController, :edit_all, as: :spell
      put "/spells/update", CharacterSpellController, :update_all, as: :spell
      put "/spells/add", CharacterSpellController, :add_all, as: :spell
      delete "/spells/remove", CharacterSpellController, :remove_all, as: :spell
    end

    # Event Routes
    post "/characters/:character_id/skill_roll", EventController, :skill_roll
    post "/characters/:character_id/spell_roll", EventController, :spell_roll

    resources "/user", UserController, only: [:delete, :edit, :update]

    # Groups
    resources "/groups", GroupController, except: [:index, :update]
    put "/groups/join/:id", GroupController, :join
    delete "/group/leave", GroupController, :leave

    live "/combat", DsaLive, :combat

    live "/spells", DsaLive, :spells
  end

  # Admin Routes
  scope "/", DsaWeb do
    pipe_through [:browser, :authenticate_user, :admin]

    resources "/skills", SkillController, except: [:index, :show]
  end
end
