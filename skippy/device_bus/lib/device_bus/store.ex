defmodule DeviceBus.Store do
  
  use GenServer

  require Logger

  @server __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  def snapshot() do
    GenServer.call(@server, {:snapshot})
  end

  def update_state(device, state) do
    GenServer.call(@server, {:update, device, state})
  end

  def handle_call({:snapshot}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:update, device, new_state}, _from, state) do
    updated = Map.update(state, device, [new_state], &([new_state|&1]))
    {:reply, updated, updated}
  end

end
