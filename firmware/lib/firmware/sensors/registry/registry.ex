defmodule BabyZoo.Sensor.Registry do

  @name __MODULE__
  @topic "sensors"

  def child_spec(_) do
    %{
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_link(_) do
    Registry.start_link(keys: :duplicate, name: @name, partitions: System.schedulers_online())
  end

  def sensors() do
    Registry.lookup(@name, @topic)
      |> Enum.map(fn {pid, _} -> pid end)
  end

  def register_sensor() do
    Registry.register(@name, @topic, [])
  end

end
