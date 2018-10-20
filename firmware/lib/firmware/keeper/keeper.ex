defmodule BabyZoo.Keeper do

  require Logger

  @server __MODULE__.Server

  def child_spec(args) do
    @server.child_spec(args)
  end

  def state() do
    GenServer.call(@server, {:get_state})
  end


end
