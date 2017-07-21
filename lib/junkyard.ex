defmodule Junkyard do
  @hand_size 5
  defmodule Card do
    defstruct id: nil, type: nil
  end

  defmodule Player do
    defstruct name: nil, id: nil, hand: []
  end

  defmodule Deck do
    @moduledoc """
    Junkyard standard deck
    """

    @doc """
    Generate a new, shuffled deck.
    """
    def new do
      [
        %Card{
          id: :block,
          type: :counter
        },
        %Card{
          id: :a_gun,
          type: :unstoppable
        }
      ]
      |> Enum.shuffle
    end
  end

  defmodule Game do
    defstruct lang: :en, deck: Deck.new, players: [], started: false, turn: 1,
        discard: []
  end
  @moduledoc """
  Junkyard core library
  """

  @doc """
  Initialize a new game.
  """
  def new(lang \\ :en) when is_atom(lang) do
    {
      :success,
      parse_message(:game_new, lang),
      %Game{}
    }
  end

  @doc """
  Given a game's state is valid, start the game.
  """
  def start(game = %Game{:players => [_, _ | _]}) do
    {
      :success,
      parse_message(:start_success, game.lang),
      %{ game | started: true }
    }
  end
  def start(game = %Game{:lang => lang}) do
    {
      :invalid_action,
      parse_message(:start_no_players, lang),
      game
    }
  end

  def player_join(game = %Game{}, player_id, player_name) when is_bitstring(player_name) do
    {
      :success,
      parse_message(:player_join, game.lang, %{player_name: player_name}),
      %{ game | players: game.players ++ [
        %{
          id: player_id, name: player_name
        }
      ]}
    }
  end

  #def play(game, player, cards) do
  #end

  def parse_message(mess, lang, options \\ %{player_name: ""}) do
    {mess, %{
      en: %{
        game_new: "A new game is about to begin. Players may now join",
        start_no_players: "No players have joined the game.",
        start_success: "Game has started.",
        player_join: "#{options.player_name} has joined."
      }
    }[lang][mess]}
  end

  @doc """
  Fills a player's hand up to @hand_size
  """
  def deal_hand(game, player) do
    {game, hand} = deal(game, @hand_size - length(player.hand), player.hand)
    new_player = %{player | :hand => hand}
    %{game | :players => replace(player, game.players, new_player)}
  end

  def replace(item, items, new_value)
  def replace(item, [], new_value), do: :error
  def replace(item, [h | t], new_value) when h == item do
    [new_value | t]
  end
  def replace(item, [h | t], new_value) do
    [h | replace(item, t, new_value)]
  end

  @doc """
  Fills out all players hands with 5 cards
  """
  def deal_hands(game = %Game{:players => players}) do
    player_hands = Enum.map(players, fn(p) -> p.hand end)
    {hands, game} = deal_hands(player_hands, game)
    players = Enum.map_reduce(players, hands, fn(player, _hands = [h | t]) -> {%{player | :hand => h}, t} end)
    %{game | :players => players}
  end
  defp deal_hands(players, game, hands \\ [])
  defp deal_hands([], game, hands) do
    {hands, game}
  end
  defp deal_hands([h | t], game, hands) do
    {game, hand} = deal(game, @hand_size - length(h), h)
    deal_hands(t, game, hands ++ [hand])
  end

  defp deal(game, n, hand \\ [])
  defp deal(game, 0, hand), do: {game, hand}
  defp deal(game, n, hand) when n < 0, do: {game, hand}
  defp deal(game = %Game{:deck => [h | t]}, n, hand) do
    deal(%Game{game | :deck => t}, n-1, [h | hand])
  end
  defp deal(game = %Game{:deck => [], :discard => discard}, n, hand) do
    deal(%Game{game | :deck => Enum.shuffle(discard), :discard => []}, n, hand)
  end
  defp deal(game = %Game{:deck => [], :discard => []}, n, hand) do
    :error
  end
end
