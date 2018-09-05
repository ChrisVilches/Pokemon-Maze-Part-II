require_relative '../point'

describe Point do
  it "should compute == correctly" do
    a = Point.new 1, 2
    b = Point.new 1, 2
    expect(a).to eq b
  end

  it "should compute != correctly" do
    a = Point.new 1, 2
    b = Point.new 2, 2
    expect(a).to_not eq b
  end

  it "construct using 0s correctly if arguments weren't passed" do
    a = Point.new 1
    b = Point.new
    expect(a).to eq Point.new(1, 0)
    expect(b).to eq Point.new(0, 0)
  end
end
