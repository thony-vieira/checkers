require 'test_helper'

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

  test 'starts with white player' do
    assert_equal :white, Game.new.acting_player
  end

  test 'acting player validation' do
    assert_equal :not_acting_player, Game.new.move(:black, [5, 0], [4, 1])
  end

  test 'piece owner validation' do
    assert_equal :piece_not_owned, Game.new.move(:white, [5, 0], [4, 1])
  end

  test 'from coordinates out of bound validation' do
    assert_equal :from_coordinates_out_of_bounds, Game.new.move(:white, [-1, -1], [0, 0])
    assert_equal :to_coordinates_out_of_bounds, Game.new.move(:white, [2, 7], [3, 9])
  end

  test 'move' do
    game = Game.new
    assert game.move(:white, [2, 3], [3, 4])
    assert game.acting_player == :black
    assert game.move(:black, [5, 2], [4, 3])
    assert game.acting_player == :white
  end

  test 'making white king' do
    game = Game.new
    clear_board(game)
    game.board.grid[6][4] = Piece.new(:white, [6, 4])
    game.board.grid[5][0] = Piece.new(:black, [5, 0])
    assert game.move(:white, [6, 4], [7, 5])
    assert game.board.grid[7][5].is_king
    assert game.move(:black, [5, 0], [4, 1])
    refute game.board.grid[4][1].is_king
  end

  test 'making black king' do
    game = Game.new
    clear_board(game)
    game.board.grid[2][7] = Piece.new(:white, [2, 7])
    game.board.grid[1][4] = Piece.new(:black, [1, 4])
    assert game.move(:white, [2, 7], [3, 6])
    refute game.board.grid[3][6].is_king
    assert game.move(:black, [1, 4], [0, 5])
    assert game.board.grid[0][5].is_king
  end

  test 'king move' do
    game = Game.new
    clear_board(game)
    game.board.grid[6][4] = Piece.new(:white, [6, 4])
    game.board.grid[1][4] = Piece.new(:black, [1, 4])
    game.move(:white, [6, 4], [7, 5])
    game.board.grid[7][5].is_king
    assert game.move(:black, [1, 4], [0, 5])
    assert game.board.grid[0][5].is_king
    assert game.move(:white, [7, 5], [2, 0])
    assert game.move(:black, [0, 5], [4, 1])
  end

  test 'king move capture' do
    game = Game.new
    clear_board(game)
    game.board.grid[6][6] = Piece.new(:white, [6, 6])
    game.board.grid[1][6] = Piece.new(:black, [1, 6])
    game.move(:white, [6, 6], [7, 5])
    game.board.grid[7][5].is_king # white king
    game.move(:black, [1, 6], [0, 5])
    game.board.grid[0][5].is_king # black king
    game.board.grid[6][4] = Piece.new(:black, [6, 4])
    game.board.grid[1][4] = Piece.new(:white, [1, 4])
    assert game.move(:white, [7, 5], [4, 2])
    assert_nil game.board.find_piece([6, 4])
    assert game.move(:black, [0, 5], [2, 3])
    assert_nil game.board.find_piece([1, 4])
  end

  test 'capture chain' do
    game = Game.new
    clear_board(game)
    game.board.grid[6][4] = Piece.new(:white, [6, 4])
    game.board.grid[1][4] = Piece.new(:black, [1, 4])
    game.move(:white, [6, 4], [7, 5])
    game.board.grid[7][5].is_king # white king
    game.move(:black, [1, 4], [0, 5])
    game.board.grid[0][5].is_king # black king
    game.board.grid[6][4] = Piece.new(:black, [6, 4])
    game.board.grid[4][2] = Piece.new(:black, [4, 2])
    game.board.grid[1][4] = Piece.new(:white, [1, 4])
    game.board.grid[3][4] = Piece.new(:white, [3, 4])
    assert game.move(:white, [7, 5], [5, 3])
    assert_nil game.board.find_piece([6, 4])
    assert game.acting_player == :white
    assert game.move(:white, [5, 3], [3, 1])
    assert_nil game.board.find_piece([4, 2])
    assert game.acting_player == :black
    assert game.move(:black, [0, 5], [2, 3])
    assert_nil game.board.find_piece([1, 4])
    assert game.acting_player == :black
    assert game.move(:black, [2, 3], [4, 5])
  end

  # test 'End game' do
  #   game = Game.new
  #   clear_board(game)
  #   game.board.grid[0][1] = Piece.new(:white, [0, 1])
  #   game.board.grid[7][0] = Piece.new(:black, [7, 0])

  #   game.move(:white, [0, 1], [1, 2])
  #   game.move(:black, [7, 0], [6, 1])
  #   game.board.remove_piece([1, 2])

  #   game.check_game_end

  #   assert_equal 'player_2_won', game.status
  # end

  private

  def clear_board(game)
    game.board.grid = Array.new(8) { Array.new(8) }
  end
end
