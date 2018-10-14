defmodule BabyZoo.HistorianTest do
  use ExUnit.Case
  doctest BabyZoo.Historian

  test "greets the world" do
    assert BabyZoo.Historian.hello() == :world
  end
end
