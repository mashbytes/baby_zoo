defmodule BabyZoo.Sensors.Bat do

  require Logger

  @behaviour BabyZoo.Sensor

  @server __MODULE__.Server

  def start_link() do
    GenServer.start_link(@server, BabyZoo.Sensor.Reading.new(:unknown, DateTime.utc_now()))
  end

  def get_state() do
    GenServer.call(@server, :get_current_state)
  end

  def get_type() do
    :noise
  end

end
