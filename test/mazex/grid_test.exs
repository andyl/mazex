defmodule Mazex.GridTest do
  use ExUnit.Case

  alias Mazex.Grid

  describe "#new/2" do
    test "makes a Grid struct" do
      grid = Grid.new(2, 2)
      assert grid.rows == 2
      assert grid.cols == 2
      assert grid.cell_ids
      assert grid.cell_map
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

  describe "#link/3" do
    test "returns a grid" do
      grid = Grid.new(2,2) |> Grid.link({0,0}, {0,1})
      assert grid
    end
  end

  describe "#link/4" do
    test "returns a grid BIDI=false" do
      grid = Grid.new(2,2) |> Grid.link({0,0}, {0,1}, false)
      assert grid
    end

    test "returns a grid BIDI=true" do
      grid = Grid.new(2,2) |> Grid.link({0,0}, {0,1}, true)
      assert grid
    end
  end

  describe "#each_row/1" do
    test "yeilds a row" do
      grid = Grid.new(2,2)
      Grid.each_row grid, fn(row) ->
        assert row
      end
    end

    test "returns a list" do
      grid = Grid.new(2,2)
      result = Grid.each_row grid, fn(row) ->
        row
      end
      assert result
    end
  end

  describe "#each_cell/1" do
    test "yeilds a cell" do
      grid = Grid.new(2,2)
      Grid.each_cell grid, fn(cell) ->
        assert cell
      end
    end

    test "returns a list" do
      grid = Grid.new(2,2)
      result = Grid.each_cell grid, fn(cell) ->
        cell
      end
      assert result
    end
  end

  describe "#random_neighbor" do
    test "returns a value" do
      grid = Grid.new(4, 2)
      cell = Grid.cell_at(grid, 0, 0)
      neighbor = Grid.random_neighbor(grid, cell)
      assert neighbor
    end
  end

  describe "#to_s/1" do
    test "makes a string" do
      grid = Grid.new(20, 20)
      result = Grid.to_s(grid)
      assert result
    end

    test "with linked row cells" do
      grid = Grid.new(2,2) |> Grid.link({0,0}, {0,1}, true)
      result = Grid.to_s(grid)
      assert result
    end

    test "with linked col cells" do
      grid = Grid.new(2,2) |> Grid.link({0,0}, {1,0}, true)
      result = Grid.to_s(grid)
      assert result
    end
  end

end
