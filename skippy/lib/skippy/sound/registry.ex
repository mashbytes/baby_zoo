defmodule Skippy.Sound.Registry do
  
  @name __MODULE__
  @topic __MODULE__

  def start_link(_) do
    Registry.start_link(
      keys: :duplicate,
      name: @name,
      partitions: System.schedulers_online()
    )
  end

  def subscribe() do
    Registry.register(@name, @topic, [])
  end
  
  def dispatch(state) do
    Registry.dispatch(@name, @topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:broadcast, state})
    end)
  end
  
end

