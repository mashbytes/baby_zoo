defmodule BabyZoo.Sensors.Bat.Impl do

  def determine_state(old_state, :rising) do
    :ok
  end

  def determine_state(old_state, :falling) do
    case old_state do
      :warning  -> :critical
      :critical -> :critical
      _         -> :warning
    end
  end

end
