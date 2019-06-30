defmodule Eagle.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:picam_http, :port)

    children = [
      worker(Picam.Camera, []),
      {Plug.Cowboy, scheme: :http, plug: Eagle.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: Eagle.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
