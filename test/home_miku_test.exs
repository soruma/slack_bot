defmodule HomeMikuTest do
  use ExUnit.Case
  doctest HomeMiku

  test "greets the world" do
    assert HomeMiku.hello() == :world
  end
end
