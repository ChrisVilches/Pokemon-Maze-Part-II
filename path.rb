class Path

  def initialize(positions)
    @positions = positions
  end

  def to_arrows()

    positions = @positions

    return nil if positions.nil?

    arrows = Array.new

    (0..positions.length-2).each do |i|

      pos1 = positions[i]
      pos2 = positions[i+1]

      if pos2.i < pos1.i
        arrows << '↑'
      elsif pos2.i > pos1.i
        arrows << '↓'
      elsif pos2.j < pos1.j
        arrows << '←'
      elsif pos2.j > pos1.j
        arrows << '→'
      else
        arrows << 'x'
      end
    end

    return arrows
  end

end
