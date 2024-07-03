class Api::V1::GamesController < ApplicationController
  before_action :set_game, %i[show update move join state possible_moves status]

  def create
    game = Game.new
    if game.save
      render json: { game_id:, access_token: game.access_token, message: 'Game created. Player 1 can start playing.' }, status: :created
    else
      render json: { errors: game.errors }, status: :unprocessable_entity
    end
  end

  def join
    if @game.second_player.nil? && @game.access_token == params[:access_token]
      @game.update(second_player: :black)
      render json: { message: 'Joined game as player 2', player: :black }, status: :ok
    else
      render json: { message: 'Invalid token or game already has two players' }, status: :unprocessable_entity
    end
  end

  def game_state
    render json: @game.board.grid
  end

  def possible_moves
    piece = @game.board.find_piece(params[:coordinates])
    if piece
      moves = @game.possible_moves(piece)
      render json: { possible_moves: moves }, status: :ok
    else
      render json: { message: 'Piece not found' }, status: :unprocessable_entity
    end
  end

  def status
    render json: { status: @game.status }
  end

  def move
    from = params[:from]
    to = params[:to]
    player = params[:player].to_sym
    move_result = @game.move(player, from, to)

    if move_result == true
      render json: { message: 'Move successful', game: @game, status: @game.status }, status: :ok
    else
      render json: { errors: move_result }, status: :unprocessable_entity
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
