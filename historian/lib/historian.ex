defmodule BabyZoo.Historian do

  require Logger

  @server __MODULE__.Server

  def start_link() do
    GenServer.start_link(@server, %{})
    Logger.debug("Starting #{@server}")
  end

  def record_latest_state(name, state) do
    GenServer.cast(@server, {:record_latest_state, name, state})
  end

end
