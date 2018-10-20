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
    Supervisor.start_link(children(), opts)
  end

  defp sensors() do
    [BabyZoo.Sensors.Bat]
  end


  defp children do
    [
      {BabyZoo.Keeper, sensors()},
    ] ++ sensors()
      ++ children(@target)
  end

  defp children("host"), do: []

  defp children(_), do: []

end
