defmodule BabyZoo.Sensors.Bat.StateMachine do

  def next_state(_, :rising) do
    :ok
  end

  def next_state(old_state, :falling) do
    case old_state do
      :warning  -> :critical
      :critical -> :critical
      _         -> :warning
    end
  end

end
