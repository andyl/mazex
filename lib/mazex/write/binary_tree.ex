defmodule Mazex.Write.BinaryTree do

  alias Mazex.Grid
  alias Mazex.Cell

  def on(grid) do
    grid.cell_ids
    |> List.flatten()
    |> Enum.reduce(grid, &linkup/2)
  end

  defp linkup(cell, grid) do
    Grid.random_neighbor(grid, cell, [:north, :east])
    |> link_cell(cell, grid)
  end

  defp link_cell(nil, _cell, grid), do: grid

  defp link_cell(neighbor, cell, grid) do
    grid
    |> Grid.link(neighbor, Cell.id(cell), true)
  end

end

# class BinaryTree
#   def self.on(grid)
#     grid.each_cell do |cell|
#       neighbors = []
#       neighbors << cell.north if cell.north
#       neighbors << cell.east if cell.east
#       index = rand(neighbors.length)
#       neighbor = neighbors[index]
#       cell.link(neighbor, bidi: true) if neighbor
#     end
#     grid
#   end
# end
