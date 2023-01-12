defmodule Mazex.Cell do
  @moduledoc """
  Struct and helper functions for Cells.
  """

  defstruct row: 0, col: 0, links: %{}

  alias Mazex.Cell

  @doc """
  Create a new cell.
  """
  def new(row, col) do
    %Cell{row: row, col: col}
  end

  @doc """
  Return the cell ID - a tuple of it's row and column.
  """
  def id(cell) do
    {cell.row, cell.col}
  end

  @doc """
  Link the tgt cell to the src cell.
  """
  def link(src, tgt) do
    newlinks = Map.merge(src.links, %{id(tgt) => true})
    %Cell{src | links: newlinks}
  end

  @doc """
  Bidirectional link from src cell to target cell.
  """
  def link(src, tgt, false) do
    {link(src, tgt), tgt}
  end

  def link(src, tgt, true) do
    {link(src, tgt), link(tgt, src)}
  end

  @doc """
  Unlink tgt cell from src cell.
  """
  def unlink(src, tgt) do
    newlinks = Map.delete(src.links, id(tgt))
    %Cell{src | links: newlinks}
  end

  @doc """
  Bidirectional link from src cell to target cell.
  """
  def unlink(src, tgt, false) do
    {unlink(src, tgt), tgt}
  end

  def unlink(src, tgt, true) do
    {unlink(src, tgt), unlink(tgt, src)}
  end

  @doc """
  Return list of IDs of linked cells.
  """
  def links(cell) do
    cell.links |> Map.keys()
  end

  @doc """
  Return true if cell2 is linked to cell1.
  """
  def linked?(cell1, cell2) do
    cell1 |> links() |> Enum.any?(id(cell2))
  end

  def north(cell), do: {cell.row - 1, cell.col}
  def south(cell), do: {cell.row + 1, cell.col}
  def west(cell),  do: {cell.row, cell.col - 1}
  def east(cell),  do: {cell.row, cell.col + 1}

  def neighbors(cell) do
    [
      north(cell),
      south(cell),
      east(cell),
      west(cell)
    ]
  end

end
