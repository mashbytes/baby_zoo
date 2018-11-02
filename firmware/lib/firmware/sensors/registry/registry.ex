defmodule BabyZoo.Sensor.Registry do

  @name __MODULE__
  @topic "sensors"

  def child_spec(args) do
    Registry.child_spec(args)
  end

  def start_link(args) do
    Registry.start_link(keys: :duplicate, name: @name, partitions: System.schedulers_online())
  end

  def subscribe() do
    Registry.register(@name, @topic, [])
  end

  def publish(status) do
    Registry.dispatch(@name, @topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:broadcast, status})
    end)
  end

  # def sensors() do
  #   Registry.lookup(@name, @topic)
  #     |> Enum.map(fn {pid, _} -> pid end)
  # end

  # def register_sensor() do
  #   Registry.register(@name, @topic, [])
  # end

end
