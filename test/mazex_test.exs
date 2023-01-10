defmodule MazexTest do
  use ExUnit.Case
  doctest Mazex

  test "greets the world" do
    assert Mazex.hello() == :world
  end
end
