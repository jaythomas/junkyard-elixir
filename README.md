# Junkyard

[![Build Status](https://travis-ci.org/jaythomas/junkyard-elixir.svg?branch=master)](https://travis-ci.org/jaythomas/junkyard-elixir)

The brawling card game for everyone, now implemented in Elixir!

- [Installation](#installation)
- [API](#API)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `junkyard` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:junkyard, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/junkyard](https://hexdocs.pm/junkyard).

## API

This is strictly a stateless module containing all the game logic.
It is intended to be wrapped by a stateful server that can handle player interaction.
The game state object (map) must be passed in to every command and an updated game map is returned.
