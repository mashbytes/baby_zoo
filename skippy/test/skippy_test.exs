defmodule SkippyTest do
  use ExUnit.Case
  doctest Skippy

  test "greets the world" do
    assert Skippy.hello() == :world
  end
end
