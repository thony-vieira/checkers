class Game
  attr_accessor :acting_player, :board, :move_history, :capture_chain, :status

  def initialize
    @acting_player = :white
    @board = Board.new
    @move_history = []
    @capture_chain = false
  end
  # before_create :generate_access_token

  def valid_move?(player, piece, pieces_between, move_type, from, to)
    return :from_coordinates_out_of_bounds unless board.in_grid_boundaries?(from)

    return :piece_not_found unless piece
    return :piece_not_owned unless piece.color == acting_player

    return :to_coordinates_out_of_bounds unless board.in_grid_boundaries?(to)
    return :to_coordinates_already_occupied if board.find_piece(to)

    return :invalid_move if move_type == :invalid_move
    return :invalid_move if move_type == :king_move && !piece.is_king
    return :invalid_move if move_type == :move && !valid_direction?(move_type, piece, from, to)
    return :invalid_move if move_type == :capture_move && !valid_capture?(move_type, piece, pieces_between)

    true
  end

  def valid_capture?(move_type, piece, pieces_between)
    return false if pieces_between.any?{ |x| x.color == piece.color }
    return false if @capture_chain && pieces_between.empty?
    return false if move_type == :capture_move && pieces_between.empty?

    true
  end

  def possible_moves(piece)
    directions = piece.is_king ? [[1, 1], [1, -1], [-1, 1], [-1, -1]] : [[1, 1], [1, -1]]
    directions.select do |row_dir, col_dir|
      new_row = piece.coordinates[0] + row_dir
      new_col = piece.coordinates[1] + col_dir
      in_bounds = @board.in_grid_boundaries?([new_row, new_col])
      in_bounds && @board.find_piece([new_row, new_col]).nil?
    end
  end

  def status
    return 'waiting for opponent' if second_player.nil?
    return "#{acting_player} turn" unless game_over?

    winning_player = move_history.last[0]
    "#{winning_player} won"
  end

  def move(player, from, to)
    return :not_acting_player unless is_acting_player?(player)

    piece = board.find_piece(from)
    pieces_between = board.find_pieces_between(from, to)
    move_type = move_type(from, to)

    valid_move_result = valid_move?(player, piece, pieces_between, move_type, from, to)
    if valid_move_result == true
      pieces_between.each { |piece| board.remove_piece(piece.coordinates) }
      board.move_piece(from, to)
      register_move(player, from, to)
      set_capture_chain(move_type, to)
      rotate_acting_player unless @capture_chain

      # check_game_end

      true
    else
      valid_move_result
    end
  end

  # def check_game_end
  #   white_pieces = @board.pieces_count(:white)
  #   black_pieces = @board.pieces_count(:black)

  #   if white_pieces.zero?
  #     self.status = 'Player_2_won'
  #     save
  #   elsif black_pieces.zero?
  #     self.status = 'Player_1_won'
  #     save
  #   end
  # end

  private

  def set_capture_chain(move_type, from)
    return @capture_chain = false if move_type == :move

    piece = board.find_piece(from)
    directions = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

    directions.each do |direction|
      to = find_max_edge(from, direction, move_type == :king_move ? 7 : 2)
      row_direction, col_direction = direction

      board.find_pieces_between(from, to).each do |piece_between|
        break if piece_between.color == piece.color

        row, col = piece_between.coordinates
        next_coordinates = [row + row_direction, col + col_direction]
        return @capture_chain = true unless board.find_piece(next_coordinates)
      end
    end
    @capture_chain = false
  end

  def find_max_edge(coordinates, direction, moves)
    return coordinates if moves.zero?

    row, col = coordinates
    row_direction, col_direction = direction
    row = [[row + row_direction, 0].max, 7].min
    col = [[col + col_direction, 0].max, 7].min
    moves -= 1
    find_max_edge([row, col], direction, moves)
  end

  def register_move(player, from, to)
    @move_history.push([player, from, to])
  end

  def is_acting_player?(player)
    acting_player == player
  end

  def rotate_acting_player
    return @acting_player = :black if acting_player == :white

    @acting_player = :white
  end

  def move_type(from, to)
    start_row, start_col = from
    end_row, end_col = to
    row_distance = end_row - start_row
    col_distance = end_col - start_col
    return :capture_move if row_distance.abs == 2 && col_distance.abs == 2
    return :move if row_distance.abs == 1 && col_distance.abs == 1
    return :king_move if row_distance == col_distance

    :invalid_move
  end

  def valid_direction?(move_type, piece, from, to)
    start_row, _start_col = from
    end_row, _end_col = to
    row_distance = end_row - start_row
    return true if move_type == :capture_move || move_type == piece.is_king
    return true if piece.color == :white && row_distance.positive?
    return true if piece.color == :black && row_distance.negative?

    false
  end
end
