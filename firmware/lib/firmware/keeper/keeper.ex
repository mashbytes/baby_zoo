defmodule BabyZoo.Keeper do

  require Logger

  @server __MODULE__.Server

  def start_link(sensors) do
    GenServer.start_link(@server, sensors, name: __MODULE__)
  end

  def state() do
    GenServer.call(@server, {:get_state})
  end


end
