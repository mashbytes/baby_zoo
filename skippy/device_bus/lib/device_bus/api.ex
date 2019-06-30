defmodule DeviceBus do

  @store __MODULE__.Store
  @registry __MODULE__.Registry

  def subscribe() do
    @store.snapshot()
    @registry.subscribe()
  end

  def snapshot() do
    @store.snapshot()
  end

  def dispatch(device, %Device.State{} = state) do
    updated = @store.update_state(device, state)
    @registry.dispatch(updated)
  end

end
