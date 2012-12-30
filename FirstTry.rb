#!/usr/bin/ruby

require 'test/unit'

solvedBoard = <<END
+-------+-------+-------+
| 9 6 3 | 1 7 4 | 2 5 8 |
| 1 7 8 | 3 2 5 | 6 4 9 |
| 2 5 4 | 6 8 9 | 7 3 1 |
+-------+-------+-------+
| 8 2 1 | 4 3 7 | 5 9 6 |
| 4 9 6 | 8 5 2 | 3 1 7 |
| 7 3 5 | 9 6 1 | 8 2 4 |
+-------+-------+-------+
| 5 8 9 | 7 1 3 | 4 6 2 |
| 3 1 7 | 2 4 6 | 9 8 5 |
| 6 4 2 | 5 9 8 | 1 7 3 |
+-------+-------+-------+
END

unsolvedBoard = <<END
+-------+-------+-------+
| _ 6 _ | 1 _ 4 | _ 5 _ |
| _ _ 8 | 3 _ 5 | 6 _ _ |
| 2 _ _ | _ _ _ | _ _ 1 |
+-------+-------+-------+
| 8 _ _ | 4 _ 7 | _ _ 6 |
| _ _ 6 | _ _ _ | 3 _ _ |
| 7 _ _ | 9 _ 1 | _ _ 4 |
+-------+-------+-------+
| 5 _ _ | _ _ _ | _ _ 2 |
| _ _ 7 | 2 _ 6 | 9 _ _ |
| _ 4 _ | 5 _ 8 | _ 7 _ |
+-------+-------+-------+
END

class Board

  attr_accessor :board
  
  # Loads the @board array from a string matching the example above.
  def load(str)
    @board = Array.new

    str.each_line do |line|
      next unless line =~ /\d|_/
      @board << line.scan(/[\d_]/).collect {|n| Integer(n) rescue 0 }
      fail "Length was #{@board.last.length}" unless @board.last.length == 9
    end

    fail "Board is not valid." unless self.valid?
  end

  def valid?
    @board.each {|row| return false unless row.length == 9}
    return false unless @board.length == 9
    return true
  end
  
  def solved?
    #the sum of each grid, row and column should be 45
    # or, more elegantly, each row, column and grid should include 1..9
    goal = (1..9).to_a
    1.upto(9) { |n| 
      return false unless (goal - self.row(n)).empty?
      return false unless (goal - self.col(n)).empty?
      return false unless (goal - self.grid(n)).empty?
    }
    return true
  end

  def row(n)
    @board[n-1]
  end
  
  def col(n)
    result = Array.new
    @board.each {|line| result << line[n-1] }
    return result
  end
  
  def gridNum(c,r)
    (r-1).div(3)*3 + (c-1).div(3) + 1
  end
  
  def togo
    @board.flatten.select {|i| i==0}.length    
  end
  
  def grid(n)
    result = Array.new
    rowGroup,colGroup = (n-1).divmod(3) #even though grids are 1-9, use as 0-8
    #colGroup, rowGroup are 0..2
    @board[(rowGroup*3),3].each {|row| result << row[colGroup*3,3] } 
    return result.flatten
  end
  
  def set(c, r, value)
    @board[r-1][c-1] = value
  end
  
  def get(c,r)
    @board[r-1][c-1]
  end
  
  def getPossible(c,r)
    # the possible numbers
    possibles = (1..9).to_a - self.col(c) - self.row(r) - self.grid(gridNum(c,r))   
  end
  
  def simplify!
    didAnything = false
    potentials = @board
    # fill potentials with the original board, then go through every 0 to enumerate
    # the possibilities for that cell.
    1.upto(9) {|c|
      1.upto(9) {|r| 
        if self.get(c,r) == 0
          #cell is unsolved
          if (self.getPossible(c,r).length == 1)
            # only one value is possible here, might as well set it
            #printf("%d,%d has %s\n", c, r, self.getPossible(c,r).to_s)
            self.set(c,r, self.getPossible(c,r)[0])
            printf("%d,%d is now %d\n", c, r, self.get(c,r))
            didAnything = true
          end
        end
        }
      
      }
      didAnything
  end

  def test(c,r)
    #c = (gets "col 1-9: ").to_i
    #r = (gets "row 1-9: ").to_i

    p "cell is: " + self.get(c,r).to_s
    #self.set(1,1,2)
    #p "cell is: " + self.get(c,r).to_s

    p "column: " + self.col(c).join(" ").to_s
    p "row: " + self.row(r).join(" ").to_s
    p "grid: " + self.grid(gridNum(c,r)).join(" ").to_s 

    p "board is " + (self.solved? ? "solved." : "NOT solved")
  end  

  def display
    ourBoard = @board
    puts horizRule = '+-------+-------+-------+'
    ourBoard.each_with_index { |line, index| 
      dispLine = '| ' << line[0,3].join(' ') << ' | ' << line[3,3].join(' ') << ' | ' << line[6,3].join(' ') << ' |'
      puts dispLine.gsub('0','_')
      puts horizRule if (index).modulo(3) == 2
    }
  end

  def test_getPossible(c,r)
    puts "loc " << c.to_s << ',' << r.to_s << ": " << self.getPossible(c,r).to_s
  end

end

me = Board.new

#puts unsolvedBoard
puts "\n\n"
me.load(unsolvedBoard)
me.display

# me.test(1,5)
# me.test_getPossible(1,5)

puts me.togo.to_s << " cells left" until !me.simplify!
me.display
p me.getPossible(5,3)
