defmodule BabyZoo.Sensors.Bat.Impl do

  @state_ttl 5_000

  def next_state(current, direction) do
    new_level = level(current.level, direction)
    new_since = since(current.level, new_level, current.since)
    %{current | level: new_level, since: new_since}
  end

  def state(current) do
    diff = DateTime.diff(current.since, DateTime.utc_now())
    if diff > @state_ttl do
      BabyZoo.Sensor.Reading.new(:ok, current.since)
    else
      current
    end
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
