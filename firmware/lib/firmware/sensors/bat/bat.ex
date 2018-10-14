defmodule BabyZoo.Sensors.Bat do

  require Logger

  @server __MODULE__.Server

  def start_link() do
    GenServer.start_link(@server, BabyZoo.SensorState.new(:sound, :unknown, DateTime.utc_now()))
  end

  def get_current_state() do
    GenServer.call(@server, :get_current_state)
  end

end
