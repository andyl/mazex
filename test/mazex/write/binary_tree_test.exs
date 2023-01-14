defmodule Mazex.Write.BinaryTreeTest do
  use ExUnit.Case

  alias Mazex.Write.BinaryTree
  alias Mazex.Grid

  describe "#on/1" do
    test "runs without error" do
      grid = Grid.new(8, 8) |> BinaryTree.on()
      assert grid
      # IO.puts "\n" <> Grid.to_s(grid)
    end
  end

end
