defmodule BatTest do
  use ExUnit.Case
  doctest Bat

  test "greets the world" do
    assert Bat.hello() == :world
  end
end
