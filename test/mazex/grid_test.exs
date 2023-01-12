defmodule Mazex.GridTest do
  use ExUnit.Case

  alias Mazex.Grid

  describe "#new/2" do
    test "makes a Grid struct" do
      grid = Grid.new(2, 2)
      assert grid.rows == 2
      assert grid.cols == 2
      assert grid.cells
    end
  end

  describe "#prep_grid/2" do
    test "makes a list of lists" do
      result = Grid.prep_grid(2, 2)
      assert result
    end
  end

  describe "#cell_flat/1" do
    test "returns a list" do
      list = Grid.new(2,2) |> Grid.cell_flat()
      assert list
    end
  end

  describe "#cell_map/1" do
    test "returns a map" do
      map = Grid.new(2,2) |> Grid.cell_map()
      assert map
    end
  end

  describe "#cell_at/3" do
    test "returns a cell" do
      cell = Grid.new(2,2) |> Grid.cell_at(1, 1)
      assert cell
    end
  end

  describe "#random_cell/1" do
    test "returns a cell" do
      cell = Grid.new(2,2) |> Grid.random_cell()
      assert cell
    end
  end

  describe "#size/1" do
    test "returns a count" do
      count = Grid.new(2,2) |> Grid.size()
      assert count == 4
    end
  end

end
