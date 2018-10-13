defmodule BabyZoo.Sensors.Bat.StateMachine do

  def next_state(current, direction) do
    new_level = level(current.level, direction)
    new_since = since(current.level, new_level, current.since)
    %{current | level: new_level, since: new_since}
  end

  defp level(_, :rising) do
    :ok
  end

  defp level(old_level, :falling) do
    case old_level do
      :warning  -> :critical
      :critical -> :critical
      _         -> :warning
    end
  end

  defp since(level, level, prev_since) do
    prev_since
  end

  defp since(_, _, _) do
    DateTime.utc_now()
  end

end
