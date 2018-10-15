defmodule BabyZoo.Sensor do

  @type sensor_type :: :temperature | :noise

  @callback get_type() :: sensor_type
  @callback get_state() :: any
end
