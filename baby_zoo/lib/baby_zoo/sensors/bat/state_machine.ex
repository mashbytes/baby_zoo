defmodule BabyZoo.Sensors.Bat.StateMachine do

  def next_level(_, :rising) do
    :ok
  end

  def next_level(old_level, :falling) do
    case old_level do
      :warning  -> :critical
      :critical -> :critical
      _         -> :warning
    end
  end

end
