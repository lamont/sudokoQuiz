#!/usr/bin/ruby

require 'cell'
require 'set'
require 'solver'

class Board

  # Loads the @board array from a string matching the example above.
  def load(str)
    tmpBoard = Array.new

    str.each_line do |line|
      next unless line =~ /\d|_/
      tmpBoard << line.scan(/[\d_]/).collect {|n| Integer(n) rescue 0 }
      fail "Length was #{tmpBoard.last.length}" unless tmpBoard.last.length == 9
    end

    @board = Set.new
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
  
  def get(c,r)
    # give me one cell that matches a specific column
    @board.select {|cell| (cell.row == r) && (cell.col == c) }.first
  end

  def getpossible(c, r)
    get(c,r).possible(@board)
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

  def simplify!
    didAnything = false
    # look for cells with only one possible value due to uniqueness of grid, row and column.
    solved_cells = @board.select { |cell| cell.possible(@board).size == 1 }
    solved_cells.each { |cell|

      didAnything = true
    }

    didAnything
  end

  def display
    ourBoard = @board
    puts horizRule = '+-------+-------+-------+'
    1.upto(9) {|r|
      dispLine = '| ' 
      dispLine <<  [1, 2, 3].map { |c| get(c,r).to_s }.join(' ') << ' | '
      dispLine <<  [4, 5, 6].map { |c| get(c,r).to_s }.join(' ') << ' | '
      dispLine <<  [7, 8, 9].map { |c| get(c,r).to_s }.join(' ') << ' | '
      puts dispLine.gsub('0','_')
      puts horizRule if (r).modulo(3) == 0
    }
  end

end
