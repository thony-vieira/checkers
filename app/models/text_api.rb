# class TextApi
#   attr_reader :game

#   def initialize
#     @game = Game.new

#     render
#     input_loop
#   end

#   def render
#     puts '   A  B  C  D  E  F  G  H'
#     game.board.grid.each_with_index do |row, i|
#       print "#{i} "
#       row.each do |piece|
#         if piece.nil?
#           print ' . '
#         else
#           print " #{piece} "
#         end
#       end
#       puts
#     end
#   end

#   def render_result(result)
#     if result == true
#       puts "Player Turn: #{game.acting_player.capitalize}"
#     else
#       puts "Error: #{result}"
#     end
#   end

#   def input_loop
#     loop do
#       puts
#       puts "Enter your move (e.g., 'D2 to C3') or 'exit':"
#       moves = gets.chomp.strip
#       return if moves == 'exit'

#       @last_move = nil
#       last_result = true
#       moves.split(',').each do |move|
#         if last_result == true
#           from_text, to_text = move.strip.split(' to ')
#           from = parse_position_text(from_text)
#           to = parse_position_text(to_text)
#           @last_move = move
#           last_result = game.move(game.acting_player, from, to)
#         end
#       end

#       render_result last_result
#       puts "Last Move: #{@last_move}"
#       render
#     end
#   end

#   def parse_position_text(text_coordinates)
#     col_id, row = text_coordinates.split('')
#     row = row.to_i
#     col = col_id.ord - 'A'.ord
#     [row, col]
#   end
# end
