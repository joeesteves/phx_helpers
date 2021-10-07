defmodule PhxHelpersTest do
  use ExUnit.Case
  doctest PhxHelpers

  test "greets the world" do
    assert PhxHelpers.hello() == :world
  end
end
