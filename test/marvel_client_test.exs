defmodule MarvelClientTest do
  use ExUnit.Case
  doctest MarvelClient

  test "greets the world" do
    assert MarvelClient.hello() == :world
  end
end
