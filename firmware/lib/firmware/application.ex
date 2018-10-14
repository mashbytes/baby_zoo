defmodule Firmware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  defp sensors() do
    [BabyZoo.Sensors.Bat]
  end

  # List all child processes to be supervised
  def children("host") do

    [
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      {BabyZoo.Keeper, sensors()},
    ] ++ Enum.map(sensors(), fn s -> {s} end)
  end

  def children(_target) do
    [
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      # {Firmware.Worker, arg},
    ]
  end
end
