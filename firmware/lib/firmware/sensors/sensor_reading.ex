defmodule BabyZoo.Sensor.Reading do

  @type level :: :ok | :warning | :critical | :unknown

  defstruct [:name, :level, :since]

  def new(name, level, since) do
    %BabyZoo.Sensor.Reading{name: name, level: level, since: since}
  end

end
