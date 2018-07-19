defmodule BabyZooTest do
  use ExUnit.Case
  doctest BabyZoo

  test "greets the world" do
    assert BabyZoo.hello() == :world
  end
end
