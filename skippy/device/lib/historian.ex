defmodule Device.Historian do

  use GenServer
  require Logger

  @server __MODULE__

  def start_link(args) do
    Logger.info("Starting historian #{@server}")
    GenServer.start_link(@server, args, name: @server)
  end

  def init(topics) do
    Enum.each(topics, fn topic -> 
      {:ok, _} = Device.Registry.subscribe(topic)
    end)
    {:ok, %{}}
  end

  def handle_info({:broadcast, topic, device, state}, g_state) do
    updated = Map.update(g_state, topic, [{device, state}], fn existing -> 
      [state | existing]
    end)
    Logger.debug("Captured broadcast to [#{inspect device}/#{inspect topic}], history is #{inspect updated}")
    {:noreply, updated}
  end

  def handle_call({:history, topic}, _from, g_state) do
    {:reply, Map.get(g_state, topic, [])}
  end

  def history(topic) do
    GenServer.call(@server, {:history, topic})
  end

end