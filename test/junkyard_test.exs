defmodule JunkyardTest do

  use ExUnit.Case
  doctest Junkyard

  test "Game should initialize" do
    game = Junkyard.new
    assert game.response == :success
    assert game.message == :game_new
  end

  test "Game should not start if there are less than two players" do
    game = Junkyard.new
    |> Junkyard.start
    assert game.response == :invalid_action
    assert game.started == false
    game = Junkyard.player_join(game, "eb045ca12", "Jay")
    |> Junkyard.start
    assert game.response == :invalid_action
    assert game.started == false
  end

  test "Game should start if valid" do
    game = Junkyard.new
    |> Junkyard.player_join("eb045ca12", "Jay")
    |> Junkyard.player_join("130cb0eba", "Jojo")
    |> Junkyard.start
    assert game.started == true
  end

end
