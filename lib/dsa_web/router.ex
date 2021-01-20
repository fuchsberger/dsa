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

    post "/login", SessionController, :create
    get "/logout", SessionController, :delete

    live "/", DsaLive, :index
    live "/character", DsaLive, :character
    live "/dashboard", DsaLive, :dashboard
    live "/roll", DsaLive, :roll
    live "/login", DsaLive, :login
    live "/change_password", DsaLive, :change_password
    live "/reset_password", DsaLive, :reset_password

    live ":path", DsaLive, :error404
  end
end
