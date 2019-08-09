defmodule Bat.Ticker do
  use Device.Ticker

  def snapshot() do
    Bat.Sensor.snapshot()
  end

  def topic() do
    Device.Sound.Topic
  end

end
