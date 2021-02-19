defmodule PltalkTest do
  use ExUnit.Case
  doctest Pltalk

  test "greets the world" do
    assert Pltalk.hello() == :world
  end
end
