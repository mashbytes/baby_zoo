defmodule BabyZoo.Sensor do
  @callback get_sensor_type() :: :sound | :temperature
  @callback get_current_state() :: any
end
