defmodule DeviceBus.Registry  do
  
  require Logger

  @name __MODULE__
  @topic __MODULE__

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

  def subscribe() do
    Logger.debug("Subscribing to registy registry [#{@name}], topic [#{@topic}]")
    Registry.register(@name, @topic, [])
  end
  
  def dispatch(state) do
    Logger.debug("Dispatching state [#{inspect state}] to registry named [#{@name}], topic [#{@topic}]")
    Registry.dispatch(@name, @topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:broadcast, state})
    end)
  end

end