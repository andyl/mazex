defmodule Mazex.Grid do

  defstruct rows: 10, cols: 10, cells: []

  alias Mazex.Grid
  alias Mazex.Cell

  def new(rows, cols) do
    %Grid{
      rows: rows,
      cols: cols,
      cells: prep_grid(rows, cols)
    }
  end

  def prep_grid(rows, cols) do
    for row <- 0..rows-1 do
      for col <- 0..cols-1 do
        Cell.new(row, col)
      end
    end
  end

  def cell_flat(grid) do
    grid.cells
    |> List.flatten()
  end

  def cell_map(grid) do
    grid
    |> cell_flat()
    |> Enum.reduce(%{}, fn(cell, acc) -> Map.merge(acc, %{Cell.id(cell) => cell}) end)
  end

  def cell_at(grid, row, col) do
    grid
    |> cell_map()
    |> Map.get({row, col})
  end

  def random_cell(grid) do
    row = Enum.random(0..grid.rows-1)
    col = Enum.random(0..grid.cols-1)
    cell_at(grid, row, col)
  end

  def size(grid) do
    grid.rows * grid.cols
  end

  def each_row(grid, func) do
    for row <- 0..grid.rows-1 do
      func.(row)
    end
  end

  def each_cell(grid, func) do
    for cell <- cell_flat(grid) do
      func.(cell)
    end
  end

end
