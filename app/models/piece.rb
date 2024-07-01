class Piece
  attr_accessor :coordinates
  attr_reader :color, :is_king

  def initialize(color, coordinates)
    @color = color
    @coordinates = coordinates
    @is_king = false
  end

  def make_king!
    @is_king = true
  end

  def to_s
    return "w" if color == :white

    'b'
  end
end
