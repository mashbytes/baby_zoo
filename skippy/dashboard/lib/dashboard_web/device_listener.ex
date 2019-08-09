defmodule DashboardWeb.DeviceListener do
  require Logger
  
  use Device.Subscriber
  
  def on_broadcast(Device.Sound.Topic, device, state) do
    Logger.debug("Received broadcast from device [#{inspect device}] [#{inspect state}]]")
  end

    def on_broadcast(topic, device, state) do
    Logger.debug("Received broadcast from topic [#{inspect topic}], device [#{inspect device}] [#{inspect state}]]")
  end

end