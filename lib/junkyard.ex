defmodule Junkyard do

  @moduledoc """
  Junkyard core library
  """

  defmodule Deck do

    @moduledoc """
    Junkyard standard deck
    """

    @doc """
    Generate a new, shuffled deck.
    """
    def new do
      [
        %{
          :id => :block,
          :type => :counter
        },
        %{
          :id => :a_gun,
          :type => :unstoppable
        }
      ]
        |> Enum.shuffle
    end

  end

  @doc """
  Initialize the game. Defaults to English since no language is provided.
  """
  def new do
    new(:en)
  end

  @doc """
  Initialize a new game.
  """
  def new(lang) when is_atom(lang) do
    {
      :success,
      parse_message(:game_new, lang),
      %{
        :deck => Deck.new,
        :lang => lang,
        :players => [],
        :started => false,
        :turn => 1
      }
    }
  end

  @doc """
  Given a game's state is valid, start the game.
  """
  def start(game) do
    if game[:players] == [] do
      {
        :invalid_action,
        parse_message(:start_no_players, game[:lang]),
        game
      }
    else
      {
        :success,
        parse_message(:start_success, game[:lang]),
        %{ game | started: true }
      }
    end
  end

  def player_join(game, player_id, player_name) when is_bitstring(player_name) do
    {
      :success,
      parse_message(:player_join, game[:lang], player_name),
      %{ game | players: [
        game[:players] | %{
          :id => player_id,
          :name => player_name
        }
      ]}
    }
  end

  #def play(game, player, cards) do
  #end

  def parse_message(message, lang) when message == :game_new do
    phrases = %{
      :en => "A new game is about to begin. Players may now join"
    }
    { message, phrases[lang] }
  end

  def parse_message(message, lang) when message == :start_no_players do
    phrases = %{
      :en => "No players have joined the game."
    }
    { message, phrases[lang] }
  end

  def parse_message(message, lang) when message == :start_success do
    phrases = %{
      :en => "Game has started."
    }
    { message, phrases[lang] }
  end

  def parse_message(message, lang, player_name) when message == :player_join do
    phrases = %{
      :en => "#{player_name} has joined."
    }
    { message, phrases[lang] }
  end

end
