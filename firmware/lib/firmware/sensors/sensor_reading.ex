defmodule BabyZoo.Sensor.Reading do

  @type level :: :ok | :warning | :critical | :unknown

  defstruct [:level, :since]

  # @spec new(type, level, DateTime.t) :: BabyZoo.SensorState.t
  def new(level, since) do
    %BabyZoo.Sensor.Reading{level: level, since: since}
  end

end
