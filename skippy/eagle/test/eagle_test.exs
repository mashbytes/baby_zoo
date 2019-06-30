defmodule EagleTest do
  use ExUnit.Case
  doctest Eagle

  test "greets the world" do
    assert Eagle.hello() == :world
  end
end
