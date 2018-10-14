defmodule BabyZoo.Keeper do

  require Logger

  @server __MODULE__.Server

  def start_link(sensors) do
    GenServer.start_link(@server, sensors, name: __MODULE__)
  end

end
