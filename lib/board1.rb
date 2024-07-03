class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }

    3.times.each do |row|
      8.times.each do |col|
        @grid[row][col] = Piece.new(:white, [row, col]) if (row + col).odd?
      end
    end

    (5..7).each do |row|
      8.times.each do |col|
        @grid[row][col] = Piece.new(:black, [row, col]) if (row + col).odd?
      end
    end
  end

  def board_state
    board_state = {}
    @board.grid.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        if cell
          board_state[[row_index, col_index]] = {
            color: cell.color,
            is_king: cell.is_king
          }
        end
      end
    end
    board_state
  end

  def pieces_count(color)
    @grid.flatten.compact.count { |piece| piece.color == color }
  end

  def remove_piece(coordinates)
    row, col = coordinates
    @grid[row][col] = nil
  end

  def move_piece(from, to)
    piece = find_piece(from)
    piece.coordinates = to
    remove_piece(from)
    end_row, end_col = to
    piece.make_king! if piece.color == :white && end_row == 7
    piece.make_king! if piece.color == :black && end_row.zero?
    @grid[end_row][end_col] = piece
  end

  def in_grid_boundaries?(coordinates)
    row, col = coordinates
    row >= 0 && row <= 7 && col >= 0 && col <= 7
  end

  def find_piece(coordinates)
    row, col = coordinates
    @grid[row][col]
  end

  def find_pieces_between(from, to)
    pieces = []
    start_row, start_col = from
    end_row, end_col = to
    row_distance = end_row - start_row
    col_distance = end_col - start_col
    row_step = row_distance.positive? ? 1 : -1
    col_step = col_distance.positive? ? 1 : -1

    (start_row + row_step..end_row - row_step).step(row_step).each do |row|
      (start_col + col_step..end_col - col_step).step(col_step).each do |col|
        piece = find_piece([row, col])
        pieces.push(piece) if piece
      end
    end

    pieces
  end
end
