require './path_calculator.rb'
require './point.rb'

def to_arrows(positions)

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
    end
  end

  return arrows
end


text = $stdin.read
lines = text.split("\n")

start = lines[0].split ' '
finish = lines[1].split ' '

start = Point.new start[0].to_i, start[1].to_i
finish = Point.new finish[0].to_i, finish[1].to_i
maze = []

(2..lines.length-1).each do |i|
  row = lines[i].split ' '
  maze << row.map(&:to_i)
end


path_calc = PathCalculator.new maze

path = path_calc.get_path start, finish

puts path.nil?? 'no' : (to_arrows path)
