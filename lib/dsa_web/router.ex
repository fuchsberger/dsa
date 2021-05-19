defmodule DsaWeb.Router do
  use DsaWeb, :router

  import DsaWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DsaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DsaWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  # Public Routes
  scope "/", DsaWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  ## Authentication routes

  scope "/", DsaWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/registrierung", UserRegistrationController, :new
    post "/registrierung", UserRegistrationController, :create
    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
    get "/passwort_zuruecksetzen", UserResetPasswordController, :new
    post "/passwort_zuruecksetzen", UserResetPasswordController, :create
    get "/passwort_zuruecksetzen/:token", UserResetPasswordController, :edit
    put "/passwort_zuruecksetzen/:token", UserResetPasswordController, :update
  end

  scope "/", DsaWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/einstellungen", UserSettingsController, :edit
    put "/einstellungen", UserSettingsController, :update
    get "/einstellungen/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", DsaWeb do
    pipe_through [:browser]

    delete "/ausloggen", UserSessionController, :delete
    get "/account_bestaetigen", UserConfirmationController, :new
    post "/account_bestaetigen", UserConfirmationController, :create
    get "/account_bestaetigen/:token", UserConfirmationController, :confirm
  end

  # # Public Routes
  # scope "/", DsaWeb do
  #   pipe_through :browser

  #   resources "/character", CharacterController, only: [:show]

  #   # Public Data Routes
  #   resources "/groups", GroupController, only: [:index]
  #   resources "/skills", SkillController, only: [:index]
  #   resources "/spells", SpellController, only: [:index]
  #   resources "/blessings", BlessingController, only: [:index]


  #   resources "/dice_tables", DiceTableController do
  #      resources "/entries", DiceTableEntryController
  #      post "/dice_table_roll", EventController, :dice_table_roll
  #   end


  #   # user registration
  #   # get "/user/confirm/:token", UserController, :confirm

  #   # reset password logic
  #   # get "/user/reset", UserController, :reset
  #   # post "/user/reset", UserController, :send_reset_link
  #   # get "/user/reset/:token", UserController, :reset_password
  #   # put "/user/reset/:token", UserController, :update_password
  # end

  # # Private Routes
  # scope "/", DsaWeb do
  #   pipe_through [:browser, :require_authenticated_user]

  #   put "/character/:id/activate", CharacterController, :activate
  #   put "/character/:id/toggle_visible", CharacterController, :toggle_visible

  #   resources "/characters", CharacterController, except: [:show] do

  #     # Combat Sets
  #     resources "/combat_sets", CombatSetController, except: [:show]

  #     # Character Skills
  #     resources "/skills", CharacterSkillController, only: [:index], as: :skill
  #     get "/skills/edit", CharacterSkillController, :edit_all, as: :skill
  #     put "/skills/update", CharacterSkillController, :update_all, as: :skill
  #     put "/skills/add", CharacterSkillController, :add_all, as: :skill
  #     delete "/skills/remove", CharacterSkillController, :remove_all, as: :skill

  #     # Character Spells
  #     resources "/spells", CharacterSpellController, only: [:index], as: :spell
  #     get "/spells/edit", CharacterSpellController, :edit_all, as: :spell
  #     put "/spells/update", CharacterSpellController, :update_all, as: :spell
  #     put "/spells/add", CharacterSpellController, :add_all, as: :spell
  #     delete "/spells/remove", CharacterSpellController, :remove_all, as: :spell

  #     # Character Blessings
  #     resources "/blessings", CharacterBlessingController, only: [:index], as: :blessing
  #     get "/blessings/edit", CharacterBlessingController, :edit_all, as: :blessing
  #     put "/blessings/update", CharacterBlessingController, :update_all, as: :blessing
  #     put "/blessings/add", CharacterBlessingController, :add_all, as: :blessing
  #     delete "/blessings/remove", CharacterBlessingController, :remove_all, as: :blessing
  #   end

  #   # Event Routes
  #   post "/characters/:character_id/skill_roll", EventController, :skill_roll
  #   post "/characters/:character_id/spell_roll", EventController, :spell_roll
  #   post "/characters/:character_id/blessing_roll", EventController, :blessing_roll

  #   # resources "/user", UserController, only: [:delete, :edit, :update]

  #   # Groups
  #   put "/groups/join/:id", GroupController, :join
  #   delete "/groups/leave", GroupController, :leave
  #   resources "/groups", GroupController, except: [:index, :update]
  # end

  # # Admin Routes
  # scope "/", DsaWeb do
  #   pipe_through [:browser, :require_authenticated_user, :admin]

  #   resources "/skills", SkillController, except: [:index, :show]
  # end

  # ## Authentication routes

  # scope "/", DsaWeb do
  #   pipe_through [:browser, :redirect_if_user_is_authenticated]

  #   get "/login", UserSessionController, :new
  #   post "/login", UserSessionController, :create
  #   get "/register", UserRegistrationController, :new
  #   post "/register", UserRegistrationController, :create

  #   get "/users/reset_password", UserResetPasswordController, :new
  #   post "/users/reset_password", UserResetPasswordController, :create
  #   get "/users/reset_password/:token", UserResetPasswordController, :edit
  #   put "/users/reset_password/:token", UserResetPasswordController, :update
  # end

  # scope "/", DsaWeb do
  #   pipe_through [:browser, :require_authenticated_user]

  #   get "/users/settings", UserSettingsController, :edit
  #   put "/users/settings", UserSettingsController, :update
  #   get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

  #   delete "/users/delete", UserSettingsController, :delete
  # end

  # # Account Management

  # scope "/accounts", DsaWeb do
  #   pipe_through [:browser]

  #   delete "/logout", UserSessionController, :delete
  #   get "/confirm", UserConfirmationController, :new
  #   post "/confirm", UserConfirmationController, :create
  #   get "/confirm/:token", UserConfirmationController, :confirm
  # end

  # scope "/accounts", DsaWeb do
  #   pipe_through [:browser, :require_authenticated_user]

  #   get "/change_password", UserChangePasswordController, :edit
  #   post "/change_password", UserChangePasswordController, :update
  # end
end
