defmodule DeviceBusTest do
  use ExUnit.Case
  doctest DeviceBus

  test "greets the world" do
    assert DeviceBus.hello() == :world
  end
end
