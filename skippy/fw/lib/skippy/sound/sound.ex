defmodule Skippy.Sound do
  
  require Logger

  @server __MODULE__.Sensor
  @registry __MODULE__.Registry

  def subscribe() do
    @registry.subscribe()
  end

  def snapshot() do
    @server.snapshot()
  end

end