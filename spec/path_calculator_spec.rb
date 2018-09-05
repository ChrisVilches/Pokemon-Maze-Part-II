require_relative '../path_calculator'
require_relative '../path'

describe PathCalculator do
  it "should be true" do

    files = Dir["./spec/data/in*"]

    files.each do |input|

      output = input.sub '/in', '/sol'

      in_text = File.read(input).strip
      out_text = File.read(output).strip
      lines = in_text.split("\n")

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

      # Assertions

      if arrows.nil?
        expect(out_text.strip).to eq 'no'
      else
        text_arrows = out_text.split ' '
        expect(text_arrows).to match_array(arrows)
      end

    end



    expect(1).to be 1
  end
end
