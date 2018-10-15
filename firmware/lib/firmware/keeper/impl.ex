defmodule BabyZoo.Keeper.Impl do

  require Logger

  def fetch_sensor_states(sensors, old_state) do
    new_states =
      sensors
      |> Enum.map(fn sensor -> {sensor, sensor.get_state()} end)
      |> Map.new

     %{old_state | states: new_states}
  end

end
