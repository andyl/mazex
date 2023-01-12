defmodule Mazex.CellTest do
  use ExUnit.Case

  alias Mazex.Cell

  describe "#new/2" do
    test "returns a struct" do
      cell = Cell.new(10, 20)
      assert cell.row == 10
      assert cell.col == 20
      assert cell.links == %{}
    end
  end

  describe "#id/1" do
    test "returns a tuple" do
      id = Cell.new(10, 20) |> Cell.id()
      assert id == {10, 20}
    end
  end

  describe "#link/2" do
    test "returns an updated cell" do
      src1 = Cell.new(1, 1)
      tgt1 = Cell.new(1, 2)
      src2 = Cell.link(src1, tgt1)
      assert src2.row == 1
      assert src2.col == 1
      assert src2.links == %{ {1, 2} => true }
    end
  end

  describe "#link/3" do
    test "with BIDI == false" do
      src1 = Cell.new(1, 1)
      tgt1 = Cell.new(1, 2)
      {src2, tgt2} = Cell.link(src1, tgt1, false)
      assert src2.row == 1
      assert src2.col == 1
      assert src2.links == %{ {1, 2} => true }
      assert tgt2 == tgt1
    end

    test "with BIDI == true" do
      src1 = Cell.new(1, 1)
      tgt1 = Cell.new(1, 2)
      {src2, tgt2} = Cell.link(src1, tgt1, true)
      assert src2.row == 1
      assert src2.col == 1
      assert src2.links == %{ {1, 2} => true }
      assert tgt2.row == 1
      assert tgt2.col == 2
      assert tgt2.links == %{ {1, 1} => true }
    end

    test "with multiple links" do
      src1 = Cell.new(1, 1)
      tgt1 = Cell.new(1, 2)
      tgt2 = Cell.new(2, 1)
      {src2, _} = Cell.link(src1, tgt1, true)
      {src3, _} = Cell.link(src2, tgt2, true)
      assert src3.links == %{ {1, 2} => true, {2, 1} => true}
    end
  end

  describe "unlink/2" do
    test "returns an updated cell" do
      src1 = Cell.new(1, 1)
      tgt1 = Cell.new(1, 2)
      src2 = Cell.link(src1, tgt1)
      assert src2.links == %{ {1, 2} => true }
      src3 = Cell.unlink(src2, tgt1)
      assert src3.links == %{ }
    end
  end

  describe "#unlink/3" do
    test "with BIDI == false" do
      src1 = Cell.new(1, 1)
      tgt1 = Cell.new(1, 2)
      {src2, tgt2} = Cell.link(src1, tgt1, true)
      assert src2.links == %{ {1, 2} => true }
      assert tgt2.links == %{ {1, 1} => true }

      {src3, tgt3} = Cell.unlink(src2, tgt2, false)
      assert src3.links == %{}
      assert tgt3.links == %{ {1, 1} => true }
    end

    test "with BIDI == true" do
      src1 = Cell.new(1, 1)
      tgt1 = Cell.new(1, 2)
      {src2, tgt2} = Cell.link(src1, tgt1, true)

      {src3, tgt3} = Cell.unlink(src2, tgt2, true)
      assert src3.links == %{}
      assert tgt3.links == %{}
    end
  end

  describe "direction functions" do
    test "#north/1" do
      {row, col} = Cell.new(5,5) |> Cell.north()
      assert row == 4
      assert col == 5
    end

    test "#south/1" do
      {row, col} = Cell.new(5,5) |> Cell.south()
      assert row == 6
      assert col == 5
    end

    test "#west/1" do
      {row, col} = Cell.new(5,5) |> Cell.west()
      assert row == 5
      assert col == 4
    end

    test "#east/1" do
      {row, col} = Cell.new(5,5) |> Cell.east()
      assert row == 5
      assert col == 6
    end

    test "#neighbors/1" do
      ids = Cell.new(5,5) |> Cell.neighbors()
      assert ids == [ {4,5}, {6,5}, {5,6}, {5,4} ]
    end
  end
end
