defmodule Game do
  @moduledoc """
  A map of the game state
  """
  defstruct lang: :en,
    # bitstring: human readable message provided from last returned command
    announce: nil,
    # list: list of %Card 's to be drawn
    deck: Deck.new,
    # list: list of %Card 's that have been discarded
    discard: [],
    # bitstring: message code corresponding to a message that can be displayed
    # The message code determines the announce string
    message: nil,
    # bitstring: ID of player being attacked
    opponent: nil,
    # list: list of %Player{} 's actively playing
    players: [],
    # atom: response code from last returned command
    response: nil,
    # boolean: whether the game is currently in play
    started: false,
    # integer: turns elapsed since play has begin
    turn: 1
end
