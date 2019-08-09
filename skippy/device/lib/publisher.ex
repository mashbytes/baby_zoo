defmodule Device.Publisher do
  use GenServer
  require Logger

  @server __MODULE__

  def start_link(arg) do
    Logger.debug("Starting Publisher [#{@server}]")
    GenServer.start_link(@server, arg, name: @server)
  end

  def init(arg) do
    {:ok, arg}
  end

  def publish(topic, device, state) do
    Logger.debug("Publishing to topic [#{topic}], device [#{inspect device}, state [#{inspect state}]")
    GenServer.cast(@server, {:broadcast, topic, device, state})
  end

  def handle_cast({:broadcast, topic, device, state}, g_state) do
    Device.Registry.publish(topic, device, state)
    {:noreply, g_state}
  end

end