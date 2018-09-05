require './path_calculator.rb'
require './point.rb'
require './path.rb'

text = $stdin.read
lines = text.split("\n")

start = lines[0].split ' '
finish = lines[1].split ' '
boulder_break_count = lines[2].to_i

start = Point.new start[0].to_i, start[1].to_i
finish = Point.new finish[0].to_i, finish[1].to_i
maze = []

(3..lines.length-1).each do |i|
  row = lines[i].split ' '
  maze << row.map(&:to_i)
end

path_calc = PathCalculator.new maze

path = path_calc.get_path(start: start, finish: finish, boulder_break_remaining: boulder_break_count)

arrows = (Path.new path).to_arrows

puts arrows.nil?? 'no' : arrows
