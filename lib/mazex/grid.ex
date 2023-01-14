defmodule Mazex.Grid do
  @moduledoc """
  Struct and helper functions for Grids.
  """

  # TODO: write @type and @typedoc
  defstruct rows: 10, cols: 10, cell_ids: [], cell_map: %{}

  alias Mazex.Grid
  alias Mazex.Cell

  @doc """
  Create a new grid.
  """
  def new(rows, cols) do
    %Grid{
      rows: rows,
      cols: cols,
      cell_ids: cell_ids(rows, cols),
      cell_map: cell_map(rows, cols)
    }
  end

  defp cell_ids(rows, cols) do
    for row <- 0..(rows - 1) do
      for col <- 0..(cols - 1) do
        {row, col}
      end
    end
  end

  defp cell_map(rows, cols) do
    cell_ids(rows, cols)
    |> List.flatten()
    |> Enum.reduce(%{}, fn {row, col}, acc ->
      Map.merge(acc, %{{row, col} => Cell.new(row, col)})
    end)
  end

  @doc """
  Return a flat list of cells.
  """
  def cell_flat(grid) do
    grid.cell_map
    |> Map.values()
  end

  @doc """
  Return a maps of cells, with the map key being a cell ID in the format of `{row, col}`.
  """
  def cell_map(grid) do
    grid.cell_map
  end

  @doc """
  Return the cell at `row`, `col`.
  """
  def cell_at(grid, row, col) do
    grid.cell_map |> Map.get({row, col})
  end

  @doc """
  Return the cell for {`row`, `col`}.
  """
  def cell_for_id(grid, {row, col} = _id) do
    cell_at(grid, row, col)
  end

  @doc """
  Return a random cell.
  """
  def random_cell(grid) do
    row = Enum.random(0..(grid.rows - 1))
    col = Enum.random(0..(grid.cols - 1))
    cell_at(grid, row, col)
  end

  @doc """
  Return the size of the grid.
  """
  def size(grid) do
    grid.rows * grid.cols
  end

  @doc """
  Link cell1 to cell2.
  """
  def link(grid, cell_id1, cell_id2) do
    map = grid.cell_map
    cell1 = map[cell_id1]
    cell2 = map[cell_id2]
    new_map = Map.merge(map, Cell.link(cell1, cell2, false))
    %Grid{grid | cell_map: new_map}
  end

  @doc """
  Bidirectional Link cell1 to cell2.
  """
  def link(grid, cell_id1, cell_id2, true) do
    map = grid.cell_map
    cell1 = map[cell_id1]
    cell2 = map[cell_id2]
    new_map = Map.merge(map, Cell.link(cell1, cell2, true))
    %Grid{grid | cell_map: new_map}
  end

  def link(grid, cell_id1, cell_id2, false) do
    map = grid.cell_map
    cell1 = map[cell_id1]
    cell2 = map[cell_id2]
    new_map = Map.merge(map, Cell.link(cell1, cell2, false))
    %Grid{grid | cell_map: new_map}
  end

  @doc """
  Run the `func` synchronously on each row of the grid.
  """
  def each_row(grid, func) do
    for row <- grid.cell_ids do
      func.(row)
    end
  end

  @doc """
  Run the `func` asynchronously on each cell.
  """
  def each_cell(%Grid{} = grid, func) do
    grid.cell_ids |> List.flatten() |> each_cell(func)
  end

  def each_cell(row, func) when is_list(row) do
    row
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await(&1))
  end

  @doc """
  Return a random neighbor cell_id.

  A) Neighbor cell must be in the list of allowed vectors (N/S/E/W).

  B) Neighbor cell must be within the bounds of grid.

  if A && B, then: random_neighbor, else: nil
  """
  def random_neighbor(grid, cell, vector \\ [:north, :south, :east, :west]) do
    Cell.neighbors(cell)
    |> vector_filter(vector)
    |> valid_cell_filter(grid)
    |> random_element()
  end

  defp vector_filter(cell_map, vector) do
    Enum.reduce cell_map, [], fn({key, val}, acc) ->
      if Enum.member?(vector, key), do: acc ++ [val], else: acc
    end
  end

  defp valid_cell_filter(list, grid) do
    Enum.filter(list, &valid_cell?(&1, grid))
  end

  defp valid_cell?({row, col}, grid) do
    max_row = grid.rows - 1
    max_col = grid.cols - 1
    Enum.member?(0..max_row, row) && Enum.member?(0..max_col, col)
  end

  defp random_element([]), do: nil
  defp random_element(list), do: Enum.random(list)

  @doc """
  Return a string representation of a grid."
  """
  def to_s(grid) do
    to_s_v1(grid)
  end

  @doc """
  Return a string representation of a grid."
  """
  def to_s_v1(grid) do
    base = "---+" |> String.duplicate(grid.cols)
    grid_top = ["+", base, "\n"]

    grid_data =
      each_row(grid, fn row ->
        row_cells =
          each_cell(row, fn cell_id ->
            base_cell = cell_for_id(grid, cell_id)
            east_cell = cell_for_id(grid, Cell.east(base_cell))
            east_mark = if Cell.linked?(base_cell, east_cell), do: " ", else: "|"
            "   #{east_mark}"
          end)

        row_border =
          each_cell(row, fn cell_id ->
            base_cell = cell_for_id(grid, cell_id)
            south_cell = cell_for_id(grid, Cell.south(base_cell))
            south_mark = if Cell.linked?(base_cell, south_cell), do: "   ", else: "---"
            "#{south_mark}+"
          end)

        ["|", row_cells, "\n", "+", row_border, "\n"]
      end)

    [grid_top, grid_data]
    |> IO.iodata_to_binary()
  end
end
