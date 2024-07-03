module Api
  module V1
    class GamesController < ApplicationController
      before_action :validate_player, only: [:move, :possible_moves]
      before_action :set_game, only: [:join, :state, :possible_moves, :status, :move]

      @@games = {}


      # POST /games
      def create
        game = Game.new
        game_id = SecureRandom.uuid
        token = SecureRandom.hex(10)
        @@games[game_id] = { game: game, player_1_token: token, player_2_token: nil }
        render json: { game_id: game_id, token: token }
      end

      # POST /games/:id/join
      def join
        if @current_player == :white && @game.second_player.nil?
          @game.update(second_player: :black)
          render json: { message: 'Joined game as player 2', player: :black }, status: :ok
        else
          render json: { error: 'Unauthorized or Player 2 already joined' }, status: :unauthorized
        end
      end

      # GET /games/:id/state
      def state
        render json: @game.board.board_state
      end

      # GET /games/:id/possible_moves
      def possible_moves
        piece = @game.board.find_piece(params[:coordinates])
        return render json: { error: 'Piece not found' }, status: :not_found unless piece

        moves = @game.possible_moves(piece)
        render json: { moves: }
      end

      # GET /games/:id/status
      def status
        render json: { status: @game.status }
      end

      # POST /games/:id/move
      def move
        from = params[:from]
        to = params[:to]
        result = @game.move(current_player, from, to)
        if result == true
          render json: { success: true }
        else
          render json: { error: result }, status: :unprocessable_entity
        end
      end

      private

      def set_game
        @game_data = @@games[params[:id]]
        @game = @game_data[:game] if @game_data
      end

      def validate_player
  token = request.headers['Authorization']
  Rails.logger.debug "Received token: #{token}"  # Verifique se o token está sendo recebido corretamente

  @current_player = if token == @game_data[:player_1_token]
                      :white
                    elsif token == @game_data[:player_2_token]
                      :black
                    else
                      nil
                    end

  Rails.logger.debug "Current player: #{@current_player}"  # Verifique qual jogador foi identificado

  unless @current_player
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end

      def current_player
        @current_player
      end
    end
  end
end
