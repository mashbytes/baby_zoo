defmodule Bat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      Device.Publisher,
      Bat.Sensor,
      Bat.Ticker,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bat.Supervisor, max_restarts: 100]
    Supervisor.start_link(children, opts)
  end
end
