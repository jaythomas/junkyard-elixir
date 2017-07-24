defmodule Util do
  @moduledoc """
  Useful, general-purpose functions that don't belong anywhere else.
  """

  @doc """
  Replace an item in a list with a new item.
  """
  def replace(item, items, new_value)
  def replace(_, [], _), do: :error
  def replace(item, [h | t], new_value) when h == item do
    [new_value | t]
  end
  def replace(item, [h | t], new_value) do
    [h | replace(item, t, new_value)]
  end


end
