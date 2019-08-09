defmodule Device.Registry  do
  
  require Logger

  @name __MODULE__

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link() do
    Logger.info("Starting Registry named [#{@name}]")
    Registry.start_link(
      keys: :duplicate,
      name: @name,
      partitions: System.schedulers_online()
    )
  end

  def subscribe(topic) do
    Logger.debug("Subscribing to [#{@name}/#{topic}]")
    Registry.register(@name, topic, [])
  end
  
  def publish(topic, device, state) do
    Logger.debug("Publishing to [#{@name}/#{topic}]: device [#{inspect device}], state [#{inspect state}]")
    Registry.dispatch(@name, topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:broadcast, topic, device, state})
    end)
  end

end