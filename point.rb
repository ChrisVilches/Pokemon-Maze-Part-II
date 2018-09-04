class Point
  attr_accessor :i, :j
  def initialize(i=0, j=0)
    @i = i
    @j = j
  end

  def move(di, dj)
    result = self.dup
    result.i = result.i + di
    result.j = result.j + dj
    return result
  end

  def ==(o)
    self.i == o.i && self.j == o.j
  end

  def to_s
    "(#{self.i}, #{self.j})"
  end
end
