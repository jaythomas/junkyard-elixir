defmodule Junkyard do

  @hand_size 5
  @max_health 10

  defmodule Card do
    defstruct id: nil, type: nil
  end

  defmodule Player do
    defstruct name: nil, id: nil, hand: [], health: nil
  end

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

  defmodule Game do
    defstruct lang: :en,
      announce: nil,
      deck: Deck.new,
      discard: [],
      message: nil,
      players: [],
      response: nil,
      started: false,
      turn: 1
  end
  @moduledoc """
  Junkyard core library
  """

  @doc """
  Initialize a new game.
  """
  def new(lang \\ :en) when is_atom(lang) do
    %{ %Game{} |
      lang: lang,
      response: :success,
      message: :game_new,
      announce: parse_message(:game_new, lang)
    }
  end

  @doc """
  Given a game's state is valid, start the game.
  """
  def start(game = %Game{:players => [_, _ | _]}) do
    #game = Enum.reduce(game.players, game, fn(player, game) ->
      #deal_hand(game, player)
    #end)
    %{ game |
      started: true,
      response: :success,
      message: :start_success,
      announce: parse_message(:start_success, game.lang)
    }
  end
  def start(game = %Game{:lang => lang}) do
    %{ game |
      response: :invalid_action,
      message: :start_no_players,
      announce: parse_message(:start_no_players, lang)
    }
  end

  def player_join(game = %Game{}, player_id, player_name) when is_bitstring(player_name) do
    %{ game |
      players: game.players ++ [
        %{
          id: player_id,
          name: player_name,
          hand: [],
          health: @max_health
        }
      ],
      response: :success,
      message: :player_join,
      announce: parse_message(:player_join, game.lang, %{player_name: player_name})
    }
  end

  #def play(game, player, cards) do
  #end

  def parse_message(message, lang, options \\ %{player_name: ""}) do
    %{
      en: %{
        game_new: "A new game is about to begin. Players may now join",
        start_no_players: "No players have joined the game.",
        start_success: "Game has started.",
        player_join: "#{options.player_name} has joined."
      }
    }[lang][message]
  end

  @doc """
  Fills a player's hand up to @hand_size
  TODO: To prevent there being more cards to deal than there are in the
  discard and deck, shuffle in an additional deck for every 8 players.
  There should also be an option to limit the game to X number of players.
  """
  def deal_hand(game, player_id) when is_bitstring(player_id) do
    player = Enum.find(game.players, fn player -> player.id == player_id end)
    deal_hand(game, player)
  end
  def deal_hand(game, player) do
    { game, new_hand } = deal(game, @hand_size - length(player.hand), player.hand)
    updated_player = %{ player | :hand => new_hand }
    %{ game | :players => replace(player, game.players, updated_player) }
  end

  def replace(item, items, new_value)
  def replace(_, [], _), do: :error
  def replace(item, [h | t], new_value) when h == item do
    [new_value | t]
  end
  def replace(item, [h | t], new_value) do
    [h | replace(item, t, new_value)]
  end

  defp deal(game, n, hand) when n < 1, do: { game, hand }
  defp deal(game = %Game{ :deck => [], :discard => discard }, n, hand) do
    deal(
      %Game{ game | :deck => Enum.shuffle(discard), :discard => [] },
      n,
      hand
    )
  end
  defp deal(game = %Game{ deck: [h | t] }, n, hand) do
    deal(
      %Game{ game | :deck => t },
      n - 1,
      [h | hand]
    )
  end
end
