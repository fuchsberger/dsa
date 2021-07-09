defmodule Dsa.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Dsa.Repo,
      # Start the Telemetry supervisor
      DsaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dsa.PubSub},
      # Start the Endpoint (http/https)
      DsaWeb.Endpoint,
      # Start a worker by calling: Dsa.Worker.start_link(arg)
      # {Dsa.Worker, arg}
    ]

    # Populate ETS storage with DSA data
    Dsa.Data.init()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dsa.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DsaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
