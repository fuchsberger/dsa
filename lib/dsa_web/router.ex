defmodule DsaWeb.Router do
  use DsaWeb, :router

  if Application.get_env(:dsa, :environment) == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
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

    # Public Data Routes
    resources "/groups", GroupController, only: [:index]
    resources "/skills", SkillController, only: [:index]
    resources "/spells", SpellController, only: [:index]
    resources "/blessings", BlessingController, only: [:index]


    resources "/dice_tables", DiceTableController do
       resources "/entries", DiceTableEntryController
       post "/dice_table_roll", EventController, :dice_table_roll
    end


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

    put "/character/:id/activate", CharacterController, :activate
    put "/character/:id/toggle_visible", CharacterController, :toggle_visible

    resources "/characters", CharacterController, except: [:show] do

      # Combat Sets
      resources "/combat_sets", CombatSetController, except: [:show]

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

      # Character Blessings
      resources "/blessings", CharacterBlessingController, only: [:index], as: :blessing
      get "/blessings/edit", CharacterBlessingController, :edit_all, as: :blessing
      put "/blessings/update", CharacterBlessingController, :update_all, as: :blessing
      put "/blessings/add", CharacterBlessingController, :add_all, as: :blessing
      delete "/blessings/remove", CharacterBlessingController, :remove_all, as: :blessing
    end

    # Event Routes
    post "/characters/:character_id/skill_roll", EventController, :skill_roll
    post "/characters/:character_id/spell_roll", EventController, :spell_roll
    post "/characters/:character_id/blessing_roll", EventController, :blessing_roll

    resources "/user", UserController, only: [:delete, :edit, :update]

    # Groups
    put "/groups/join/:id", GroupController, :join
    delete "/groups/leave", GroupController, :leave
    resources "/groups", GroupController, except: [:index, :update]
  end

  # Admin Routes
  scope "/", DsaWeb do
    pipe_through [:browser, :authenticate_user, :admin]

    resources "/skills", SkillController, except: [:index, :show]
  end
end
