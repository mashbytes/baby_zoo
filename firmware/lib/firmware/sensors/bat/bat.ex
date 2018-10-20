defmodule BabyZoo.Sensors.Bat do

  require Logger

  @behaviour BabyZoo.Sensor

  @server __MODULE__.Server

  def child_spec(args) do
    @server.child_spec(args)
  end

  def get_state() do
    GenServer.call(@server, :get_state)
  end

  def get_type() do
    :noise
  end

end
