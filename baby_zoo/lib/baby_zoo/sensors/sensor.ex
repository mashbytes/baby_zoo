defmodule BabyZoo.Sensor do
  @callback get_current_state() :: {:ok, BabyZoo.SensorState} | {:error, String.t}
end
