defmodule Deck do
  @moduledoc """
  Junkyard standard deck
  """

  @doc """
  Generate a new, shuffled deck.
  """
  def new do
    List.duplicate(%Card{
      id: :a_gun,
      type: :unstoppable
    }, 20) ++
    List.duplicate(%Card{
      id: :block,
      type: :counter
    }, 20)
    |> Enum.shuffle
  end
end
