#!/usr/bin/ruby

require 'cell'
require 'set'

class Board

  # Loads the @board array from a string matching the example above.
  def load(str)
    tmpBoard = Array.new

    str.each_line do |line|
      next unless line =~ /\d|_/
      tmpBoard << line.scan(/[\d_]/).collect {|n| Integer(n) rescue 0 }
      fail "Length was #{tmpBoard.last.length}" unless tmpBoard.last.length == 9
    end

    @board = Array.new    
    tmpBoard.each_with_index { |row, r| 
      row.each_with_index {|col, c|
        #inc r, c, because I want to index from 1, not 0
        @board << Cell.new(c+1,r+1,tmpBoard[r][c])
      }
    }

    fail "Board is not valid." unless self.valid?
  end

  def valid?
    # check that we've got 9 cells for each row, column and grid
    1.upto(9) {|i|
      cols = @board.select {|cell| cell.col == i}
      return false unless cols.length == 9
      rows = @board.select {|cell| cell.row == i}
      return false unless rows.length == 9
      grids = @board.select {|cell| cell.grid == i}
      return false unless grids.length == 9
    }    
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
  
  def one(r,c)
    # give me one cell that matches a specific row and column
    @board.select {|cell| (cell.row == r) && (cell.col == c) }.first
  end

  def row(n)
    @board.select {|cell| cell.row == n}
  end

  def col(n)
    @board.select {|cell| cell.col == n}
  end

  def grid(n)
    @board.select {|cell| cell.grid == n}
  end

  def togo
    @board.select {|cell| cell.unsolved? }.length    
  end

  def setPossible(cell)
    # load an unsolved cell with the possible values
    cell.possibles = (1..9).to_a - @board.map { |somecell| 
      somecell.value if (somecell.row == cell.row) or (somecell.col == cell.col) or (somecell.grid == cell.grid)
    }
    #possibles = (1..9).to_a - self.col(c) - self.row(r) - self.grid(gridNum(c,r))   
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

  def display
    ourBoard = @board
    puts horizRule = '+-------+-------+-------+'
    1.upto(9) {|r|
      dispLine = '| ' 
      dispLine << one(r,1)
#      dispLine <<  [1, 2, 3].each { |c| one(r,c).to_s }
#      << ' | ' 
 #     << line[3,3].join(' ') 
  #    << ' | ' 
   #   << line[6,3].join(' ') 
    #  << ' |'
      puts dispLine.gsub('0','_')
      puts horizRule if (r).modulo(3) == 2
    }
  end

end
