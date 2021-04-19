defmodule DETest do
  use ExUnit.Case
  doctest DE

  test "greets the world" do
    assert DE.hello() == :world
  end
end
