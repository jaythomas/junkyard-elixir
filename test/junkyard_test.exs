defmodule JunkyardTest do

  use ExUnit.Case
  doctest Junkyard

  test "Game should initialize" do
    { response, { message, _ }, game } = Junkyard.new
    assert response == :success
    assert message == :game_new
    assert is_map(game)
  end

  test "Game should not start if invalid" do
    { _, _, game } = Junkyard.new
    { response, _, game } = Junkyard.start(game)
    assert response == :invalid_action
    assert game[:started] == false
  end

  test "Game should start if valid" do
    { _, _, game } = Junkyard.new
    { _, _, game } = Junkyard.player_join(game, "eb045ca12", "Jay")
    { _, _, game } = Junkyard.start(game)
    assert game[:started] == true
  end

end
