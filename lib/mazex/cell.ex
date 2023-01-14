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
  def id({row, col}) do
    {row, col}
  end

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
    %{id(src) => link(src, tgt), id(tgt) => tgt}
  end

  def link(src, tgt, true) do
    %{id(src) => link(src, tgt), id(tgt) => link(tgt, src)}
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
    %{id(src) => unlink(src, tgt), id(tgt) => tgt}
  end

  def unlink(src, tgt, true) do
    %{id(src) => unlink(src, tgt), id(tgt) => unlink(tgt, src)}
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
  def linked?(_cell, nil) do
    false
  end

  def linked?(cell1, cell2) do
    cell1.links
    |> Map.keys()
    |> Enum.any?(&(id(cell2) == &1))
  end

  def north({row, col}), do: {row - 1, col}
  def north(cell), do: {cell.row - 1, cell.col}

  def south({row, col}), do: {row + 1, col}
  def south(cell), do: {cell.row + 1, cell.col}

  def  west({row, col}), do: {row, col - 1}
  def  west(cell), do: {cell.row, cell.col - 1}

  def  east({row, col}), do: {row, col + 1}
  def  east(cell), do: {cell.row, cell.col + 1}

  def neighbors(cell_id) when is_tuple(cell_id) do
    %{
      north: north(cell_id),
      south: south(cell_id),
      east:   east(cell_id),
      west:   west(cell_id)
    }
  end

  def neighbors(cell) do
    cell
    |> id()
    |> neighbors()
  end

end
