
# defines a single cell, to be a part of a grid

class Cell

  attr_accessor :value, :possible, :grid

  def initialize(c,r,v)
    @possible = Array.new
    @locX = c
    @locY = r
    @value = v
    @grid = (r-1).div(3)*3 + (c-1).div(3) + 1
  end

  def col 
    @locX 
  end

  def row
    @locY
  end

  def solved?
    @value != 0
  end

  def unsolved?
    !self.solved?
  end

  def to_i
    @value
  end

  def to_s
    (@value == 0 ? "_" : @value).to_s
  end

end


