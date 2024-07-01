require "test_helper"

class GameTest < ActiveSupport::TestCase
  #    0  1  2  3  4  5  6  7
  # 0  .  w  .  w  .  w  .  w
  # 1  w  .  w  .  w  .  w  .
  # 2  .  w  .  w  .  w  .  w
  # 3  .  .  .  .  .  .  .  .
  # 4  .  .  .  .  .  .  .  .
  # 5  b  .  b  .  b  .  b  .
  # 6  .  b  .  b  .  b  .  b
  # 7  b  .  b  .  b  .  b  .

  test "starts with white player" do
    assert_equal :white, Game.new().acting_player
  end

  test "acting player validation" do
    assert_equal :not_acting_player, Game.new().move(:black, [5, 0], [4, 1])
  end

  test "piece owner validation" do
    assert_equal :piece_not_owned, Game.new().move(:white, [5, 0], [4, 1])
  end

  test "from coordinates out of bound validation" do
    assert_equal :from_coordinates_out_of_bounds, Game.new().move(:white, [-1,-1], [0, 0])
    assert_equal :to_coordinates_out_of_bounds, Game.new().move(:white, [2, 7], [3, 9])
  end

  test "move" do
    game = Game.new
    assert game.move(:white, [2,3], [3,4])
    assert game.acting_player == :black
    assert game.move(:black, [5,2], [4,3])
    assert game.acting_player == :white
  end

  test "making white king" do
    game = Game.new
    clear_board(game)
    game.board.grid[6][4] = Piece.new(:white, [6,4])
    game.board.grid[5][0] = Piece.new(:black, [5,0])
    assert game.move(:white, [6,4], [7,5])
    assert game.board.grid[7][5].is_king
    assert game.move(:black, [5,0], [4,1])
    refute game.board.grid[4][1].is_king
  end

  test "king move" do

  end

  test "king move capture" do

  end

  test "capture chain" do

  end

  private
  def clear_board(game)
    game.board.grid = Array.new(8) { Array.new(8) }
  end
end
