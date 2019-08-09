defmodule Dashboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # List all child processes to be supervised
    children = [
      supervisor(Phoenix.PubSub.PG2, [Dashboard.PubSub, [pool_size: 1]]),

      # Start the endpoint when the application starts
      DashboardWeb.Endpoint,
      Dashboard.Presence,
      {DashboardWeb.DeviceListener, Device.Sound.Topic},
      # Starts a worker by calling: Dashboard.Worker.start_link(arg)
      # {Dashboard.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
