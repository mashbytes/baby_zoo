defmodule BabyZoo.Historian do

  require Logger

  @server __MODULE__.Server

  def record_latest_state(name, state) do
    GenServer.cast(@server, {:record_latest_state, name, state})
  end

end
