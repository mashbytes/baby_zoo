defmodule BabyZoo.Keeper do

  require Logger

  @server __MODULE__.Server

  def state() do
    GenServer.call(@server, {:get_state})
  end


end
