defmodule Skippy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Skippy.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # {Skippy.Sound.Sensor, []},
      # {Skippy.Sound.Registry, []},
      # Starts a worker by calling: Skippy.Worker.start_link(arg)
      # {Skippy.Worker, arg},
    ]
  end

  def children(_target) do
    [
      {Skippy.Sound.Sensor, []},
      {Skippy.Sound.Registry, []},
      # Starts a worker by calling: Skippy.Worker.start_link(arg)
      # {Skippy.Worker, arg},
    ]
  end
end
