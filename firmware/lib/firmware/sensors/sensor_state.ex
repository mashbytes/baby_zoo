defmodule BabyZoo.SensorState do

  @type type  :: :sound | :temperature
  @type level :: :ok | :warning | :critical | :unknown

  defstruct [:type, :level, :since]

  # @spec new(type, level, DateTime.t) :: BabyZoo.SensorState.t
  def new(type, level, since) do
    %BabyZoo.SensorState{type: type, level: level, since: since}
  end

  # def new(type) do
  #
  # end

end
