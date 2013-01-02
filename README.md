sudokoQuiz
==========

a sudoko puzzle solver in ruby

Back in 2005 or so, I was learning ruby and attempted this quiz:

http://www.rubyquiz.com/quiz43.html

My "solution":

* never fully worked (still doesn't)
* used a 2d array and various clever math tricks to operate on cells
* was hard to read
* had a bunch of nested for loops.

I've been doing a lot more ruby lately and wanted to revisit this and refactor it in a more object oriented style, with the idea that I could make the complicated expressions more readable and eliminate nested for loops.

It's not fast, it's just meant to be readable and extendable as a programming exercise.

I've tried to make the cell objects smarter so that I can operate on them as sets. Previously their position
in the @board array dictated their position in the grid, which lead to horrors.  For example, this was my
original method for simplifying the board based on finding cells with only one possible value:

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

but with more knowledge of ruby and some refactoring, I was able to replace that with the below:

      def simplify!
        not @board.select { |cell| cell.possible(@board).size == 1 && cell.unsolved? }.each { |cell|
          cell.value = cell.possible(@board).first
        }.empty?
        # returns true if it solved anything, false if no changes were made
      end

Someday I'll look at the quiz answers, but I'd like to solve this properly once.

