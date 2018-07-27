defmodule BabyZoo.SensorTick do

  @type type  :: :sound | :temperature
  @type state :: :ok | :warning | :critical

  defstruct [:type, :state, :time]

  @spec new(type, state, DateTime.t) :: number
  def new(type, state, time) do
    %BabyZoo.SensorTick {type: type, state: state, time: time}
  end

end
