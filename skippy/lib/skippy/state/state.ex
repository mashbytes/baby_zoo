defmodule Skippy.Sensor.State do

  @type level :: :active | :inactive

  defstruct [:level, :trigger, :since]

  def new(level, trigger, since) do
    %Skippy.Sensor.State{level: level, trigger: trigger, since: since}
  end
  
end

defimpl String.Chars, for: Skippy.Sensor.State do
  def to_string(%Skippy.Sensor.State{level: level, trigger: trigger, since: since}) do
    "{#{level}, #{trigger}, #{since}}"
  end
end
